<?php
require_once("../connec.inc.php");
require_once("./traitProduitParent.php");

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

// Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header("Location: crudProduit.php"); // On redirige vers la page
    exit();
}


/**
 * Permet de traiter l'action "declinaison"
 * 
 */
function traiterDeclinaison(array $donnees)
{
    global $connection;
    $photos_deplaces = [];
    try {

        //Vérifier les champs du formulaire
        validerChamps($donnees);

        // Récupération des valeurs
        $idDeclinaison = $donnees['idDeclinaison'] ?? '';
        $images_upload = $_FILES['images'] ?? null; //Images uploadées (pas encore enregistrées)
        $idProduit = $donnees['idProduitParent'];
        $libelle = trim($donnees['libelleDeclinaison']);
        $description = trim($donnees['descriptionDeclinaison']);
        $fiche = trim($donnees['ficheTechniqueDeclinaison']);
        $prix = max(0, (float)$donnees['prix']);
        //On prend le prix solde si il existe et qu'il est différent de ''. Sinon on prend null
        $prixSolde = isset($donnees['prixSolde']) && $donnees['prixSolde'] != '' ? max(0, (float)$donnees['prixSolde']) : null;
        $qteStock = max(0, (int)$donnees['qteStock']);
        $seuilQte = max(0, (int)$donnees['seuilQte']);
        $qualite = trim($donnees['qualite']);
        $provenance = trim($donnees['provenance']);

        //On récupère les photos à garder (celles soumises dans le formulaire dans le tab images existantes)
        $photosAGarder = $donnees['images_existantes'] ?? []; // URLs/chemins que JS a renvoyés
        //On récup les photos que l'utilisateur veut supprimer
        $photosASupprimer = recupererPhotosASupprimer($idDeclinaison, $photosAGarder); //Tableau contenant seulement les url des images supprimées par l'utilisateur

        $connection->beginTransaction();

        // On vérifie que le produit parent existe
        testerProduitParent($idProduit);

        $action = '';
        //Cas UPDATE de la déclinaison
        if ($idDeclinaison) {
            // Si l'id de la déclinaison est présent, on fait un update
            testerDeclinaisonProduit($idDeclinaison); //Vérif l'existance
            updateDeclinaison($idDeclinaison, $idProduit, $libelle, $description, $fiche, $prix, $prixSolde, $qteStock, $seuilQte, $qualite, $provenance);
            $action = 'update';
        }
        //CAS INSERT DE LA DECLINAISON
        else {
            // Sinon on fait un insert
            insererDeclinaison($idProduit, $libelle, $description, $fiche, $prix, $prixSolde, $qteStock, $seuilQte, $qualite, $provenance);
            $action = 'insert';
            $idDeclinaison = $connection->lastInsertId();
        }

        //GESTION IMAGES UPLOAD (lors de la création ou modification de la déclinaison)
        traiterUploadImage($idDeclinaison, $images_upload, $photos_deplaces);
        
        //Suppression des photos que l'utilisateur à choisit d'enlever
        //On supprime les anciennes photos de la BD
        if (!empty($photosASupprimer)) {
            foreach ($photosASupprimer as $url) {
                deletePhotosDeclinaisonBD($idDeclinaison, $url);
            }
        }

        $connection->commit(); // Valider les modifications

        //On supprime du serveur les anciennes photos du serveur
        supprimerPhotosServeur($photosASupprimer);
        return $action;

    } catch (PDOException $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        
        // Nettoyer les fichiers uploadés partiellement
        supprimerPhotosServeur($photos_deplaces);


        error_log($e->getMessage());
        return "Erreur inattendue lors de l'enregistrement de la déclinaison.";
    } catch (Exception $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        
        // Nettoyer les fichiers uploadés partiellement
        supprimerPhotosServeur($photos_deplaces);
        return "Erreur : " . $e->getMessage();
    }
}


/**
 * Insère la déclinaison dans la base de données
 */
function insererDeclinaison($idProduit, $libelle, $desc, $fiche, $prix, $prixSolde, $qteStock, $seuilQte, $qualite, $provenance)
{
    global $connection;

    $statement = $connection->prepare("
        INSERT INTO DeclinaisonProduit 
        (idProduit, libelleDeclinaison, descDeclinaison, ficheTechnique, prix, prixSolde, qteStock, seuilQte, qualite, provenance)
        VALUES 
        (:idProduit, :libelle, :desc, :fiche, :prix, :prixSolde, :qteStock, :seuilQte, :qualite, :provenance)
    ");

    $statement->execute([
        ':idProduit' => $idProduit,
        ':libelle' => $libelle,
        ':desc' => $desc,
        ':fiche' => $fiche,
        ':prix' => $prix,
        ':prixSolde' => $prixSolde,
        ':qteStock' => $qteStock,
        ':seuilQte' => $seuilQte,
        ':qualite' => $qualite,
        ':provenance' => $provenance
    ]); // Exécuter la commande
}


/**
 * Met à jour une déclinaison existante
 */
function updateDeclinaison($idDeclinaison, $idProduit, $libelle, $desc, $fiche, $prix, $prixSolde, $qteStock, $seuilQte, $qualite, $provenance)
{
    global $connection;

    $statement = $connection->prepare("
        UPDATE DeclinaisonProduit SET 
            idProduit = :idProduit,
            libelleDeclinaison = :libelle,
            descDeclinaison = :desc,
            ficheTechnique = :fiche,
            prix = :prix,
            prixSolde = :prixSolde,
            qteStock = :qteStock,
            seuilQte = :seuilQte,
            qualite = :qualite,
            provenance = :provenance
        WHERE idDeclinaison = :idDeclinaison
    ");

    $statement->execute([
        ':idDeclinaison' => $idDeclinaison,
        ':idProduit' => $idProduit,
        ':libelle' => $libelle,
        ':desc' => $desc,
        ':fiche' => $fiche,
        ':prix' => $prix,
        ':prixSolde' => $prixSolde,
        ':qteStock' => $qteStock,
        ':seuilQte' => $seuilQte,
        ':qualite' => $qualite,
        ':provenance' => $provenance
    ]); // Exécuter la commande
}


/**
 * Permet de tester l'existance d'une déclinaison d'un produit
 */
function testerDeclinaisonProduit($idDeclinaison)
{
    global $connection;
    $statement = $connection->prepare("SELECT COUNT(*) FROM DeclinaisonProduit WHERE idDeclinaison = :id");
    $statement->execute([':id' => $idDeclinaison]);
    if ($statement->fetchColumn() == 0) {
        throw new Exception("Déclinaison introuvable !");
    }
}

/**
 * Permet de déplacer et d'insérer les images d'une déclinaison
 */

function insererEtDeplacerImages($fichiers, $idDeclinaison, &$photos_deplaces)
{
    global $connection;
    
    $uploadDir = __DIR__ . '/../images'; //Chemin absolu
    if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);

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
        $nom_fichier = uniqid('decl_' . $idDeclinaison . '_') . '.' . $ext; //Image avec un id unique
        //Destination du fichier
        $destination = $uploadDir . '/' . $nom_fichier;

        //Test déplacement échoué
        if (!move_uploaded_file($tmpName, $destination)) {
            throw new Exception("Impossible de déplacer l'image: " . $name);
        }

        //On ajoute l'image dans le tableau des fichiers ayant réussi à etre déplacé
        $photos_deplaces[] = $destination;

        //Url un peu différente pour y accéder sur le web
        $urlWeb = '/~R2025SAE3005/images/' . $nom_fichier;

        // Insérer en base 
        $stmt = $connection->prepare("INSERT INTO PhotoProduit (idDeclinaison, url) VALUES (:idDeclinaison, :urlweb)");
        $stmt->execute([
            ':idDeclinaison' => $idDeclinaison,
            ':urlweb' => $urlWeb
        ]);
    }

    
}

/**
 * Permet de vérifier la cohérence des données du formulaire
 */
function validerChamps($donnees)
{
    // Champs obligatoires
    $champsRequis = [
        'idProduitParent',
        'libelleDeclinaison',
        'descriptionDeclinaison',
        'ficheTechniqueDeclinaison',
        'prix',
        'qteStock',
        'seuilQte',
        'qualite',
        'provenance'
    ];

    // On parcourt tous les champs obligatoires
    foreach ($champsRequis as $champ) {
        // Si le champ obligatoire n'est pas présent dans les données en entrée
        // Ou que la valeur du champ est vide
        if (!isset($donnees[$champ]) || trim($donnees[$champ]) == '') {
            throw new Exception('Champ manquant ou vide : ' . $champ);
        }
    }
    if(isset($donnees['prixSolde'])){
        if($donnees['prixSolde'] >= $donnees['prix']){
            throw new Exception("Le prix soldé doit être inférieur au prix de base !");
        }
    }
}

/**
 * Permet d'obtenir toutes les photos d'une déclinaison
 * 
 */
function getPhotosDeclinaison($idDeclinaison)
{
    global $connection;
    $photos = [];
    $statement = $connection->prepare("SELECT * FROM PhotoProduit WHERE idDeclinaison = :id");
    $statement->execute([':id' => $idDeclinaison]);
    while ($ligne = $statement->fetch(PDO::FETCH_ASSOC)) {
        $photos[] = $ligne['url'];
    }

    return $photos;
}

/**
 * Permet de supprimer de la base de données toutes les photos
 * d'une déclinaison
 */
function deletePhotosDeclinaisonBD($idDeclinaison, $url)
{
    global $connection;
    $statement = $connection->prepare("DELETE FROM PhotoProduit WHERE idDeclinaison = :id AND url =:url");
    $statement->execute([':id' => $idDeclinaison, ':url' => $url]);
}

/**
 * Permet de supprimer du serveur appache les anciennes images
 */
function supprimerPhotosServeur($photos)
{
    // On récup le vrai dossier des images
    $uploadDir = __DIR__ . '/../images'; 
    foreach ($photos as $photoUrl) {
        // Extraire juste le nom du fichier depuis l'URL
        $nomFichier = basename($photoUrl);
        $cheminFichier = $uploadDir . '/' . $nomFichier;
        if (file_exists($cheminFichier)) { //Suppression des fichiers
            unlink($cheminFichier);
        }
    }
}

/**
 * Permet de récupérer un tableau des photos 
 * qu'il faut supprimer de la BD et du serveur
 */
function recupererPhotosASupprimer($idDeclinaison, array $photosAGarder)
{
    $photosExistantes = getPhotosDeclinaison($idDeclinaison); // toutes les photos déjà en BD
    // Les photos à supprimer = existantes en BD mais non conservées
    $photosASupprimer = array_diff($photosExistantes, $photosAGarder);

    return $photosASupprimer;
}

/**
 * Permet d'insérer dans la BD et déplacer les images sur le serveur
 */
function traiterUploadImage($idDeclinaison, $images, &$photos_deplaces){
    //Si au moins une image à été uploadée
    if ($images && !empty($images['name'][0])) { //Au moins une image recue
        //On insère et on déplace sur le serveur les nouvelles images
        
        insererEtDeplacerImages($images, $idDeclinaison, $photos_deplaces);
    }

}
