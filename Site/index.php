<?php
ob_start();
$user = "root";
$password = "";

require "connec.inc.php";
require "includes/getRarityColor.php";
require_once './includes/utils.php';

// --- Appel de la procédure stockée pour les produits vedettes ---
try {
    $stmt = $connection->query("CALL getTopProduitsAccueil()");
    $vedettes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Important pour éviter les erreurs avec PDO + procédures stockées
    while ($stmt->nextRowset()) {
        // vider les résultats restants
    }
} catch (PDOException $e) {
    $vedettes = [];
}
?>

<?php

$produits_recents = [];
if (isset($_COOKIE['historique_vu'])) {
    $ids = json_decode($_COOKIE['historique_vu'], true);
    
    if (!empty($ids)) {
        // Sécurité de base : on s'assure que ce sont des nombres
        $ids_clean = array_filter($ids, 'is_numeric');
        $liste_sql = implode(',', $ids_clean);

        if (!empty($liste_sql)) {
            try {
                $stmt_hist = $connection->query("CALL getProduitsHistorique('$liste_sql')");
                $produits_recents = $stmt_hist->fetchAll(PDO::FETCH_ASSOC);
                $stmt_hist->closeCursor();
            } catch (PDOException $e) {
                // En cas d'erreur, on laisse le tableau vide
            }
        }
    }
}
?>

<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>

<body class="font-body bg-parchemin h-full">

    <?php include_once 'includes/header.php'; ?>
    <!-- Message erreur/succes -->
    <?php if (isset($_GET['msgErreur']) && $_GET['msgErreur'] != null) { //Si message erreur présent on l'affiche
        afficherMessage($_GET['msgErreur'], 'erreur');
    } else if (isset($_GET['msgSucces']) && $_GET['msgSucces'] != null) { //Si message succes présent on l'affiche
        afficherMessage($_GET['msgSucces'], 'succes');
    }
    ?>

    <div id="section-accueil" class="section-content">
        <!-- Bannière Héroïque -->
        <section class="relative w-full py-20 overflow-hidden">
            <div class="absolute inset-0 bg-gradient-to-br from-green-900 via-green-800 to-green-950 opacity-95"></div>
            <div class="absolute inset-0" style="background-image: url('data:image/svg+xml,%3Csvg width=\" 100\ height="\&quot;100\&quot;" xmlns="\&quot;http://www.w3.org/2000/svg\&quot;%3E%3Cpath" d="\&quot;M50" 0l100 50 100 0 50z\ fill="\&quot;%23F9A825\&quot;" fill-opacity="\&quot;.05\&quot;/%3E%3C/svg%3E');" background-size: 50px 50px;></div>
            <div class="relative max-w-7xl mx-auto px-4 text-center">
                <div class="mb-8">
                    <img src="images/logo.png"
                        alt="Logo"
                        class="w-60 h-60 mx-auto mb-4 rounded-3xl">
                </div>
                <h2 class="font-display text-4xl md:text-6xl text-yellow-400 mb-4 text-shadow-gold animate-fadeIn" id="hero-title">Découvrez les artefacts forgés</h2>
                <p class="text-xl md:text-3xl text-yellow-200 mb-8 animate-fadeIn animate-delay-1" id="hero-subtitle">dans les flammes de Falconia</p><a href="catalogue.php" class="inline-block bg-yellow-500 hover:bg-yellow-600 text-green-900 px-8 py-4 rounded-full font-semibold text-lg transition-all transform hover:scale-105 glow-gold animate-fadeIn animate-delay-2"> Explorer la Boutique </a>
            </div>
        </section>


        <!-- Section Artefacts Vedettes -->
        <section class="w-full bg-gray-50 py-16 px-4">

            <div class="max-w-7xl mx-auto">
                <!-- Si au moins 1 vedette est présente -->
                <?php if (count($vedettes) > 0) : ?>
                    <h2 class="font-display text-4xl text-green-800 text-center mb-12">Artefacts Vedettes</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" id="featured-products">

                        <!-- ---------------------------------------------------- -->
                        <!--  PLACEHOLDER PHP : DÉBUT DE BOUCLE DES PRODUITS VEDETTES  -->
                        <!-- ---------------------------------------------------- -->

                        <?php foreach ($vedettes as $prod):
                            genererVignetteProduit($prod['idDeclinaison'], $prod['libelleDeclinaison'], $prod['prix'], $prod['prixSolde'], $prod['qualite'], $prod['nomProduit'])
                        ?>
                        <?php endforeach; ?>


                        <!-- ---------------------------------------------------- -->
                        <!--  PLACEHOLDER PHP : FIN DE BOUCLE DES PRODUITS VEDETTES  -->
                        <!-- ---------------------------------------------------- -->

                    </div>
                <?php endif; ?>
            </div>
        </section>

            <?php if (!empty($produits_recents)) : ?>
                <section class="w-full py-12 px-4 bg-gray-50 border-t border-gray-200">
                    <div class="max-w-7xl mx-auto">
                        <h2 class="font-display text-3xl text-green-800 mb-8">Consultés récemment</h2>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                            <?php foreach ($produits_recents as $p) : 
                                genererVignetteProduit($p['idDeclinaison'], $p['libelleDeclinaison'], $p['prix'], $p['prixSolde'], $p['qualite'], $p['nomProduit']);
                            endforeach; ?>
                        </div>
                    </div>
                </section>
            <?php endif; ?>

    </div>

    <?php include_once 'includes/footer.php'; ?>
    <?php ob_end_flush(); ?>