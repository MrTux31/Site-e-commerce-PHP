<?php

/**
 * Traiter la requete entrante
 * 
 */
session_start();
require_once("./connec.inc.php");
require_once("./includes/utils.php");


$erreur = '';
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $origine = $_POST['origine'] ?? null; //On récup l'origine de la page qui a fait la requete
    $id = $_POST["idProduit"] ?? null; //Si l'id produit est présent on le récup sinon null
    $qte = $_POST["qte"] ?? 1; //Si la qte est présente on la récup, sinon 1
    
    
    //SITUATION 1 : SIMPLE AJOUT PANIER (1 seul produit avec une quantité précise)
    if (isset($_POST['panier'])) { //Simple ajout au panier

        if ($id) { //Si l'id n'est pas null
            $erreur = ajoutPanier($id, $qte); //On ajoute au panier

        }
    }

    //SITUATION 2 : ACHAT DIRECT DEPUIS LE CATALOGUE (1 seul produit) REDIRECTION VERS PAGE PAIEMENT
    if (isset($_POST['achat'])) {
        try{ //Try catch car construireTabProduits peut lancer une exception en cas de produit non trouvé ou produit indisponible
            $tab_produit_achete = [$id => $qte]; //Le produit acheté est : l'id recu et la qte 1
            $tab_produit_achete = construireTabProduits($tab_produit_achete); //On récupère toutes les infos des produits (tableau enrichi)
            $_SESSION['panier'] = $tab_produit_achete; //On enregistrer l'id du produit dans la session

            // Redirection vers la page paiement
            header("Location: paiement.php");
            exit;
        }catch(Exception $e){
            header("Location: consultProduit.php?id=".$id."&msgErreur=".urlencode($e->getMessage()));
            exit;
        }
        
    }

    //SITUATION 3 : ACHAT DE PLUSIEURS PRODUITS DEPUIS LE PANIER, REDIRECTION VERS PAGE PAIEMENT
    if (isset($_POST['achatPanier'])) {
        
        try{ //Try catch car construireTabProduits peut lancer une exception en cas de produit non trouvé ou produit indisponible
            $panier = getPanier(); //On récup tous les produits ajoutés au panier et la qte
            $tab_produit_achete = construireTabProduits($panier); //On récupère toutes les infos des produits (tableau enrichi)
            $_SESSION['panier'] = $tab_produit_achete; //On enregistrer l'id du produit dans la session

            // Redirection vers la page paiement
            header("Location: paiement.php");
            exit;

        }catch(Exception $e){
            header("Location: panier.php?&msgErreur=".urlencode($e->getMessage()));
            exit;
        }
    }



    //si il y a eu une erreur d'ajout ex : stock max atteint, et que la page de la requete etait consult produit on redirige la bas avec erreur
    if ($origine == "consultProduit") {
        $message = "Produit ajouté avec succès !"; //Message de succès. Le message d'erreur s'il y en a un prends le dessus
        header("Location: consultProduit.php?id=" . $id . "&msgErreur=" . urlencode($erreur) . "&msgSucces=" . urlencode($message));
        exit;
    }


    //Après ajout au panier / ou échec, on redirige vers la page précédente 
    $previous = $_SERVER['HTTP_REFERER'] ?? 'index.php';
    header("Location: $previous");
    exit;
} else { //Acces a la page sans post
    header('Location: catalogue.php');
    exit;
}


/**
 * Permet d'ajouter un produit (avec sa qte) dans le panier 
 */
function ajoutPanier($idProduit, $qte)
{

    $panier = getPanier(); //Récupération du panier

    //On récup la qte en stock du produit dans la BD
    $qteDispoProduit = getQuantiteDispo($idProduit);

    
    //qte actuelle du produit dans le panier soit elle existe soit on l'initialise à 0 
    $qte_actuelle = isset($panier[$idProduit]) ? $panier[$idProduit] : 0;
    //La qte a ajouter dans le panier est soit : la somme de la précédente avec la nouvelle  Ou bien la qte max du produit
    $qte_a_sauvegarder_dans_panier = min($qte_actuelle + $qte, $qteDispoProduit);

    //On sauvegarde la qte mise à jour dans le panier                                                                                                 
    $panier[$idProduit] = $qte_a_sauvegarder_dans_panier;

    
    //Si la quantité à baissé en dessous de 0 on suppr le produit
    if ($panier[$idProduit] <= 0 || $qte == 0 ) { //$qte = 0 arrive quand on clique direct sur "supprimer"
        unset($panier[$idProduit]);
    }
    
    //Mettre à jour le cookie (on enregistre en json), 14 jours
    setcookie('panier', json_encode($panier), time() + (14 * 24 * 60 * 60), '/');

    //Return une erreur au cas où la qte était dépassée (erreur non blocante juste informative)
    if ($qte_actuelle + $qte > $qteDispoProduit) {
        return "La quantité en stock maximale est de " . $qteDispoProduit . "\n" . "Quantité déjà présente dans le panier : " . $qte_a_sauvegarder_dans_panier;
    }
    return null; //Pas d'erreur renvoyée
}

/**
 * Permet de lire le panier stocké dans le cookie et de le retourner sous forme de tableau associatif.
 *
 * - Si le cookie "panier" n'existe pas, un tableau vide est retourné.
 * - Si le contenu du cookie est invalide ou corrompu, le panier est réinitialisé.
 * 
 * [ 1=>2, 3=>2 ] (id produit et quantité)
 */
function getPanier()
{
    //On récup le panier déjà existant si il existe
    $panier = [];
    if (isset($_COOKIE['panier'])) {

        $panier = json_decode($_COOKIE['panier'], true); //On récup le panier en un tableau associatif

        if (!is_array($panier)) { //Si le panier est corrompu / incorrect
            $panier = [];
        }
    }
    return $panier;
}




/**
 * Permet de construire un tableau enrichi des produits a partir d'un tableau en entrée : 
 * exemple d'entrée : [ 1=>2, 2=>3 ]
 * exemple de sortie : 
 * [
 *       'idDeclinaison' => 1,
 *       'libelle' => 'Potion de mana majeure',
 *       'prix' => 19.99,
 *       'quantite' => 1
 * ]
 * 
 */
function construireTabProduits($tab_produits)
{

    $tab_enrichi = [];
    
    foreach ($tab_produits as $id => $quantite) {
        //On récup les infos du produits grace a son id dans la BD
        $infos_produit = getInfosProduits($id);
       
        
        //Si aucune info sur le produit n'est trouvée / vérification du stock du produit
        if ($infos_produit == null || $infos_produit['qteStock'] == 0) { 
            throw new Exception('Produit '.$id.' indisponible !');//On lève une exception
        }

        //Stock dispo mais pas assez par rapport à la qte demandée
        if($infos_produit['qteStock'] < $quantite){
            throw new Exception('Pas assez de stock pour le produit '.$id.'.  Stock restant : '.$infos_produit['qteStock']);
        }

        //Traitement en cas de prix soldé
        $prix = 0;
        if ($infos_produit['prixSolde'] != null) { //On prend le prix soldé
            $prix = $infos_produit['prixSolde'];
        } else {
            $prix = $infos_produit['prix']; //On prends le prix hors soldes
        }
        //On ajoute le produit à la liste dans le tableau enrichit
        $tab_enrichi[] = ['idDeclinaison' => $id, 'libelle' => $infos_produit['libelleDeclinaison'], 'prix' => $prix, 'quantite' => $quantite];
    }
    

    return $tab_enrichi;
}



/*** Récupérer les infos d'un produit dans la BD
 * Exemple de return : ['idDeclinaison'=>1,'prix'=>200,'libelleDeclinaison' => 'Potion' .....]
*/
function getInfosProduits($idDeclinaison)
{
    
    try {
        global $connection;
        //On récup la qte restante du produit
        $stmt = $connection->prepare("SELECT * FROM DeclinaisonProduit WHERE idDeclinaison = :idDeclinaison");
        $stmt->execute(['idDeclinaison' => $idDeclinaison]);


        $produit = $stmt->fetch(PDO::FETCH_ASSOC);
        if(empty($produit)){
            return null;
        }
        return $produit;
        
    } catch (PDOException $e) {
        error_log("Erreur SQL getInfosProduits : " . $e->getMessage());
    }
    return null; //En cas d'exception
}
