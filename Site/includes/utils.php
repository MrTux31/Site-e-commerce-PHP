<?php
// Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header("Location: index.php"); //On redirige vers la page
}


function placeholderUrl(string $text): string
{
    $encoded = urlencode($text);
    return "https://placehold.co/400x400/228B22/FFFFFF?text={$encoded}";
}

/**
 * Fonction permettant de charger les photos d'un produit
 */
function chargerPhotosProduit($idDeclinaison, $libelleDeclinaison)
{
    global $connection;
    $photos = [];

    try {
        $stmt = $connection->prepare("CALL getPhotosProduit(:idDeclinaison)");
        $stmt->execute(['idDeclinaison' => $idDeclinaison]);
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $photos[] = $row['url'];
        }
        $stmt->closeCursor();
    } catch (PDOException $e) { //Aucune photo trouvée
        $photos[] = 'https://placehold.co/400x400/228B22/FFFFFF?text=' . $libelleDeclinaison; //Afficher un place holder si l'image n'est pas trouvée
    }

    return $photos;
}


/**
 * Permet de savoir si le client peut déposer un avis, c'est à dire :
 * 1) Le produit à déjà été acheté au moins une fois par un client
 * 2) Le client n'a pas encore déposé d'avis sur le produit (droit à 1 seul avis)
 */
function isAvisAutorise($idClient, $idProduit)
{
    try {
        global $connection;
        // Appel de la fonction stockée
        $stmt = $connection->prepare("SELECT isProduitAvisPossible(:idClient, :idDeclinaison) AS achete");
        $stmt->execute(['idClient' => $idClient, 'idDeclinaison' => $idProduit]);

        $estAchete = $stmt->fetch();

        if ($estAchete['achete'] > 0) { //Si il a bien acheté
            return true;
        }

        return false;
    } catch (PDOException $e) {

        error_log("Erreur SQL isAvisAutorise : " . $e->getMessage());

        //en cas d'erreur on retourne false pour empecher l'avis
        return false;
    }
}

?>

<!-- Fonction permettant de générer la carte d'un produit-->
<?php function genererVignetteProduit($idDeclinaison, $titreProduit, $prix, $solde, $qualite, $libelleProduit, $taille = 'normale')
{
    // Définir les classes selon la taille
    $classes = $taille === 'petite' ? 'min-w-[220px] max-w-[220px]' : 'min-w-[280px]'; //Si petite : largeur max et min de 220px exactement
    $hauteurImage = $taille === 'petite' ? 'h-36' : 'h-48'; //Hauteur de l'image
    $tailleTexte = $taille === 'petite' ? 'text-base' : 'text-lg';  //Taille texte si petite : text-base = 16px
    $paddingCard = $taille === 'petite' ? 'p-3' : 'p-4'; // p-3 = padding de 12px sur tous les côtés sinon p-4 = padding de 16px sur tous les côtés
?>
    <!-- CARTE PRODUIT-->
    <div class="bg-white rounded-xl shadow-md <?php echo $paddingCard; ?> hover:shadow-xl hover:scale-105 transition-all duration-300 relative <?php echo $classes; ?> flex-shrink-0">
        <span class="absolute top-3 right-3 <?php echo getRarityColor($qualite); ?> text-xs px-2 py-1 rounded font-semibold"><?php echo htmlentities($qualite); ?></span>
        <div class="w-full <?php echo $hauteurImage; ?> bg-gradient-to-br  rounded-lg flex items-center justify-center mb-3 glow-green overflow-hidden">
            <img src="<?php echo htmlentities(chargerPhotosProduit($idDeclinaison, $titreProduit)[0]); ?>" alt="<?php echo htmlentities($titreProduit); ?>" class="w-full h-full object-cover rounded-lg" onerror="this.onerror=null;this.src='https://placehold.co/400x400/228B22/FFFFFF?text=Image introuvable';" />
        </div>
        <h3 class="<?php echo $tailleTexte; ?> font-display text-green-800 mt-3 truncate" title="<?php echo htmlspecialchars($titreProduit); ?>"><?php echo htmlspecialchars($titreProduit); ?></h3>
        <p class="text-gray-600 text-sm line-clamp-2"><?php echo  htmlentities($libelleProduit); ?></p>
        <div class="flex items-center gap-2 mt-1">
            <?php if ($solde !== null): ?>
                <span class="text-red-500 line-through mr-2 text-sm"><?= $prix ?> €</span>
                <span class="text-green-700 font-bold <?php echo $tailleTexte; ?>"><?php echo $solde . "€"; ?></span>
            <?php else : ?>
                <span class="text-green-700 font-bold <?php echo $tailleTexte; ?>"><?php echo $prix . "€"; ?></span>
            <?php endif; ?>
        </div>
        <a href="consultProduit.php?id=<?php echo $idDeclinaison ?>" class="w-full bg-green-700 hover:bg-green-800 text-white rounded-lg py-2 mt-3 transition-all text-center block text-sm">
            Voir les Détails
        </a>

        <?php $qte_dispo = getQuantiteDispo($idDeclinaison) //On récup la qte dispo du produit

        ?>

        <!-- Bouton ajouter au panier seulement si le produit a une qte en stock > 0-->
        <?php if ($qte_dispo > 0): ?>
            <form action="ajoutPanier.php" method="POST">
                <input type="hidden" name="idProduit" value="<?= $idDeclinaison ?>">
                <input type="hidden" name="qte" value="1">
                <button type="submit" name="panier" class="w-full bg-yellow-500 hover:bg-yellow-600 text-green-900 rounded-lg py-2 mt-2 transition-all font-semibold text-sm">
                    Ajouter au panier
                </button>
            </form>
            <!-- Bouton "Hors stock si plus de qte dispo"-->
        <?php else: ?>
            <button type="button" disabled class="w-full bg-gray-400 text-white rounded-lg py-2 mt-2 font-semibold text-sm cursor-not-allowed">
                Hors stock
            </button>
        <?php endif; ?>



    </div>
<?php } ?>



<?php
/**
 * Affiche un message formaté (erreur ou succès)
 * 
 * @param string $message  Le texte à afficher
 * @param string $type     "erreur" ou "succes"
 */
function afficherMessage($message, $type)
{
    // Sécurisation du message pour éviter les injections
    $message = nl2br(htmlspecialchars($message)); //nl2br pour les \n

    // Détermine le style en fonction du type
    if ($type === "erreur") {
        $classes = "bg-red-100 border border-red-300 text-red-700";
    } else {
        $classes = "bg-green-100 border border-green-300 text-green-700";
    }

    echo '<div class="w-full py-3 bg-white">'; //py : padding top et bottom
    echo '<div class="max-w-6xl mx-auto">';
    // Affichage du bloc formaté
    echo "
        <div class=\"mb-4 p-2 rounded-lg $classes text-center\">
            $message
        </div>
        </div>
        </div>
    ";
}


/**
 * Permet de récup la qte de stock d'un produit
 */
function getQuantiteDispo($idProduit)
{
    try {
        global $connection;
        //On récup la qte restante du produit
        $stmt = $connection->prepare("SELECT qteStock FROM DeclinaisonProduit WHERE idDeclinaison = :idDeclinaison");
        $stmt->execute(['idDeclinaison' => $idProduit]);
        $qte_dispo = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$qte_dispo) { //Si aucun résultat n'est renvoyé
            return 0;
        }

        return $qte_dispo['qteStock'];
    } catch (PDOException $e) {
        error_log("Erreur SQL isQuantiteProduitDispo : " . $e->getMessage());

        return 0;
    }
}

/**
 * Permet de retirer du panier tous les articles qui sont hors-stock
 * Modifie le tableau passé en entrée
 * Prends en paramètre le tableau du panier : 
 * [ 1=>2, 3=>4] //id produit => qte
 */
function nettoyerPanier(&$tableau_panier){
    //On parcours les produits du panier et leurs qte ajoutées
    foreach ($tableau_panier as $idProduit => $qte){
        $qte_dispo_reellement = getQuantiteDispo($idProduit);
        if($qte_dispo_reellement == 0){ //Si le stock est de 0 alors on supprime le produit du panier.
            unset($tableau_panier[$idProduit]);
        }
        //Si il reste un peut de stock, alors on met dans le panier la qte max.
        else if($qte > $qte_dispo_reellement){ //si le panier contient une quantité en stock plus grande que ce qu'il y a réellement
             $tableau_panier[$idProduit] = $qte_dispo_reellement;
        }
    }

}
?>