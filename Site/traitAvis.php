<?php session_start();
require './connec.inc.php';
require_once './includes/utils.php';



// Vérifie que l'utilisateur est arrivé par un POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}

if(!isset($_POST['idProduit'])){
    header("Location: index.php?msgErreur=".urlencode("ID du produit non spécifié."));
    exit;
}

// Vérifie que tous les champs obligatoires sont présents
if (!isset($_POST['envoiAvis'], $_POST['note'])) {
    header("Location: consultProduit.php?id=" . $_POST['idProduit'] . "&msgErreur=" . urlencode("Merci de compléter tous les champs obligatoires."));
    exit;
}

// Vérifie que l'utilisateur est connecté et autorisé à déposer un avis
if (!isset($_SESSION["idClient"])|| !isAvisAutorise($_SESSION["idClient"], $_POST['idProduit'])) {
    header("Location: consultProduit.php?id=" . $_POST['idProduit'] . "&msgErreur=" . urlencode("Vous n'êtes pas autorisé à déposer un avis sur ce produit."));
    exit;
}

//On traite l'ajout de l'avis qui remonte potentiellement une erreur
$erreur = traiterAvis($_POST);

// Redirection finale selon le résultat
if ($erreur) {
    $msgErreur = urlencode($erreur);
    header("Location: consultProduit.php?id=" . $_POST['idProduit'] . "&msgErreur=" . $msgErreur);
    exit;
} else {
    $msgSucces = urlencode("Avis ajouté avec succès !");
    header("Location: consultProduit.php?id=" . $_POST['idProduit'] . "&msgSucces=" . $msgSucces);
    exit;
}


/**
 * Permet de traiter l'ajout d'un avis en découpant en diverses
 * étapes : vérifications champs, insertion avis, insertion photos et annulation en cas d'erreurs
 */

function traiterAvis(array $donnees){
    
    global $connection;
    //Permet de garder une trace des photos déplacées sur le serveur en cas d'échec, permet de supprimer celles qui ont commencées à s'upload
    $photos_deplaces = []; 
    try{
        validerChamps($donnees);
        //Récupération des valeurs
        $idProduit = $donnees['idProduit'];
        $note = $donnees['note'];
        //Si un commentaire est envoyé et qu'il est différent de '', on le prends, sinon null
        $commentaire = isset($donnees['commentaire']) && trim($donnees['commentaire']) != ''? trim($donnees['commentaire']) : null;
        //Récupération des images uploadées ou null
        $images = $_FILES['imageMedia'] ?? null;
        date_default_timezone_set('Europe/Paris');
        $date = date('Y-m-d H:i:s'); // Date actuelle au format DATETIME

        //Début de la transaction
        $connection->beginTransaction();
        insererAvis($_SESSION['idClient'],$note, $idProduit, $commentaire, $date);
        $idAvis = $connection->lastInsertId();

        //Essaie d'uploader des images seulement si des photos sont reçues
        traiterUploadImageAvis($idAvis, $images,$photos_deplaces);
        
        //On valide les ajouts en base de données
        $connection->commit(); // Valider les modifications
    }
    //Gestion exceptions
    catch(PDOException $e){
        //Annuler les changements
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        supprimerPhotosAvisServeur($photos_deplaces);
        error_log($e->getMessage());
        return "Erreur inattendue lors de l'enregistrement de l'avis'";
        
    }catch(Exception $e){
        //Annuler les changements
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        supprimerPhotosAvisServeur($photos_deplaces);
        return "Erreur : " . $e->getMessage();

    }
    return null; //On retourne rien en  cas de succès
    
}


/**
 * Permet d'insérer un avis dans la base de données
 */
function insererAvis($idClient, $note, $idProduit, $commentaire, $date)
{
    
    global $connection;
    $statement = $connection->prepare("
        INSERT INTO Avis (idClient, note, idDeclinaisonProduit, commentaire, dateAvis)
        VALUES (:idClient, :note, :idDeclinaisonProduit, :commentaire, :dateAvis)
    ");
    //Insérer l'avis
    $statement->execute([
        ':idClient'   => $idClient,
        ':note'       => $note,
        ':idDeclinaisonProduit'  => $idProduit,
        ':commentaire' => $commentaire,
        ':dateAvis'   => $date
    ]);

    
    
}



/**
 * Permet de vérifier la cohérence des données du formulaire
 */
function validerChamps($donnees)
{
    // Champs obligatoires
    $champsRequis = [
        'note','idProduit'
    ];

    // On parcourt tous les champs obligatoires
    foreach ($champsRequis as $champ) {
        // Si le champ obligatoire n'est pas présent dans les données en entrée
        // Ou que la valeur du champ est vide
        if (!isset($donnees[$champ]) || trim($donnees[$champ]) == '') {
            throw new Exception('Champ manquant ou vide : ' . $champ);
        }
    }
    if ($donnees['note'] < 0 || $donnees['note'] > 5) {
        throw new Exception("Note invalide. Doit être comprise entre 0 et 5.");
    }
}

/**
 * Permet d'insérer dans la BD et déplacer les images sur le serveur
 */
function traiterUploadImageAvis($idAvis, $images, &$photos_deplaces){
    //Si au moins une image à été uploadée
    if ($images && !empty($images['name'][0])) { //Au moins une image recue
        //On insère et on déplace sur le serveur les nouvelles images
        
        insererEtDeplacerImagesAvis($images, $idAvis, $photos_deplaces);
    }

}
/**
 * Permet de déplacer et d'insérer les images d'une déclinaison
 */

function insererEtDeplacerImagesAvis($fichiers, $idAvis, &$photos_deplaces)
{
    global $connection;
    
    $uploadDir = __DIR__ . '/images/avis';
    if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);

    //Si plus de 4 photos ont été envoyées
    if (count($fichiers['name']) > 4) {
        throw new Exception("Maximum 4 images autorisées.");
    }

    foreach ($fichiers['name'] as $key => $name) {
        $extensions_autorisees = ['jpg', 'jpeg', 'png'];
        $tmpName = $fichiers['tmp_name'][$key];
        $error = $fichiers['error'][$key];
        $infosfichier = pathinfo($name); //On récup les infos du fichier
        $extension_upload = strtolower($infosfichier['extension']);

        //Test extension
        if (!in_array($extension_upload, $extensions_autorisees)) { //On compare l'extension du fichier aux extensions autorisées
            throw new Exception("L'image " . $name . " n'est pas au format jpg/jpeg/png !");
        }

        //Test erreurs survenues
        if ($error !== UPLOAD_ERR_OK) {
            throw new Exception("Erreur lors de l'upload de l'image: " . $name);
        }

        //Extension
        $ext = pathinfo($name, PATHINFO_EXTENSION);
        //Création du nom du fichier
        $nom_fichier = uniqid('avis_' . $idAvis . '_') . '.' . $ext; //Image avec un id unique
        //Destination du fichier
        $destination = $uploadDir . '/' . $nom_fichier;

        //Test déplacement échoué
        if (!move_uploaded_file($tmpName, $destination)) {
            throw new Exception("Impossible de déplacer l'image: " . $name);
        }

        //On ajoute l'image dans le tableau des fichiers ayant réussi à etre déplacé
        $photos_deplaces[] = $destination;

        //Url un peu différente pour y accéder sur le web
        $urlWeb = '/~R2025SAE3005/images/avis/' . $nom_fichier;

        // Insérer en base 
        $stmt = $connection->prepare("INSERT INTO PhotoAvis (idAvis, url) VALUES (:idAvis, :urlweb)");
        $stmt->execute([
            ':idAvis' => $idAvis,
            ':urlweb' => $urlWeb
        ]);
    }

    
}


/**
 * Permet de supprimer du serveur appache les anciennes images
 * Utilisé en cas d'échec lors de l'ajout d'un avis
 */
function supprimerPhotosAvisServeur($photos)
{
    // On récup le vrai dossier des images
    $uploadDir = __DIR__ . '/images/avis'; 
    foreach ($photos as $photoUrl) {
        // Extraire juste le nom du fichier depuis l'URL
        $nomFichier = basename($photoUrl);
        $cheminFichier = $uploadDir . '/' . $nomFichier;
        if (file_exists($cheminFichier)) { //Suppression des fichiers
            unlink($cheminFichier);
        }
    }
}