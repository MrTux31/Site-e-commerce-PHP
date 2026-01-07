<?php
ob_start();
require 'connec.inc.php';
require_once './includes/utils.php';

?>

<!doctype html>
<html lang="fr" class="h-full">
<?php include 'includes/head.php'; ?>

<body class="font-body bg-parchemin h-full">
    <?php include 'includes/header.php'; ?>

    <?php

    /* --------------------
   Lecture du cookie
-------------------- */
    //Le cookie est lu par Header.php,
    //Les références à la variable $panier sont donc de header.php qui fournit cette variable de panier "nettoyée" (produits hors stock enlevés)
    

    /* --------------------
   Récupération produits
-------------------- */
    $panierDetails = [];
    if (!empty($panier)) {
        foreach ($panier as $idDeclinaison => $qte) {
            $stmt = $connection->prepare("
            SELECT
                dp.idDeclinaison,
                dp.prix,
                dp.prixSolde,
                dp.libelleDeclinaison,
                p.libelle
            FROM DeclinaisonProduit dp
            INNER JOIN Produit p ON p.idProduit = dp.idProduit
            WHERE dp.idDeclinaison = ?
        ");
            $stmt->execute([$idDeclinaison]);
            $produit = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($produit) {
                $panierDetails[] = [
                    'id'        => $idDeclinaison,
                    'nom'       => $produit['libelle'] . ' - ' . $produit['libelleDeclinaison'],
                    'libelleDeclinaison' => $produit['libelleDeclinaison'],
                    'prix'      => $produit['prix'],
                    'prixSolde' => $produit['prixSolde'],
                    'quantite'  => $qte
                ];
            }
        }
    }

    /* --------------------
   Calculs
-------------------- */
    $sousTotal = 0;
    $total = 0;
    foreach ($panierDetails as $item) {
        $sousTotal += $item['prix'] * $item['quantite'];
        $total += ($item['prixSolde'] ?? $item['prix']) * $item['quantite'];
    }
    $reduction = $sousTotal - $total;


    ?>




    <!-- Message erreur/succes -->
    <?php if (isset($_GET['msgErreur']) && $_GET['msgErreur'] != null) { //Si message erreur présent on l'affiche
        afficherMessage($_GET['msgErreur'], 'erreur');
    } else if (isset($_GET['msgSucces']) && $_GET['msgSucces'] != null) { //Si message succes présent on l'affiche
        afficherMessage($_GET['msgSucces'], 'succes');
    }

    ?>
    <div class="section-content w-full py-16 px-4 bg-white min-h-[60vh]">
        <div class="max-w-4xl mx-auto">

            <h2 class="font-display text-4xl text-green-800 text-center mb-10">Votre Panier</h2>

            <?php if (!empty($panierDetails)) : ?>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    <!-- LISTE -->
                    <div class="lg:col-span-2 flex flex-col gap-3">

                        <?php foreach ($panierDetails as $item):
                            $photos = chargerPhotosProduit($item['id'], $item['libelleDeclinaison']);
                            $imgUrl = $photos[0] ?? 'https://placehold.co/400x400/228B22/FFFFFF?text=Produit';
                        ?>
                            <div class="flex justify-between items-center py-3 border-b gap-4">

                                <!-- Image cliquable -->
                                <a href="consultProduit.php?id=<?= $item['id'] ?>" class="w-24 h-24 rounded-lg overflow-hidden flex-shrink-0 hover:opacity-80 transition">
                                    <img src="<?= $imgUrl ?>" alt="<?= htmlspecialchars($item['nom']) ?>" class="w-full h-full object-cover">
                                </a>

                                <!-- Infos et boutons -->
                                <div class="flex-1 flex flex-col gap-1">
                                    <p class="font-semibold"><?= htmlspecialchars($item['nom']) ?></p>

                                    <p class="text-sm text-gray-600">
                                        <?= $item['quantite'] ?> ×
                                        <?php if ($item['prixSolde'] !== null): ?>
                                            <span class="line-through text-red-600 mr-1"><?= number_format($item['prix'], 2, ',', ' ') ?> €</span>
                                            <span class="text-green-700 font-semibold"><?= number_format($item['prixSolde'], 2, ',', ' ') ?> €</span>
                                        <?php else: ?>
                                            <span class="text-green-700 font-semibold"><?= number_format($item['prix'], 2, ',', ' ') ?> €</span>
                                        <?php endif; ?>
                                    </p>

                                    <div class="flex gap-2 mt-1">
                                        <!-- Bouton - -->
                                        <form action="ajoutPanier.php" method="post">
                                            <input type="hidden" name="idProduit" value="<?= $item['id'] ?>">
                                            <input type="hidden" name="qte" value="-1">
                                            <button type="submit" name="panier" class="px-2 py-1 bg-red-600 text-white rounded text-xs">-</button>
                                        </form>

                                        <!-- Bouton + -->
                                        <form action="ajoutPanier.php" method="post">
                                            <input type="hidden" name="idProduit" value="<?= $item['id'] ?>">
                                            <input type="hidden" name="qte" value="1">
                                            <button type="submit" name="panier" class="px-2 py-1 bg-green-600 text-white rounded text-xs">+</button>
                                        </form>

                                        <!-- Bouton Supprimer -->
                                        <form action="ajoutPanier.php" method="post">
                                            <input type="hidden" name="idProduit" value="<?= $item['id'] ?>">
                                            <input type="hidden" name="qte" value="0">
                                            <button type="submit" name="panier" class="px-2 py-1 bg-gray-500 text-white rounded text-xs hover:bg-gray-600">
                                                Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <div class="text-green-700 font-semibold whitespace-nowrap">
                                    <?= number_format(($item['prixSolde'] ?? $item['prix']) * $item['quantite'], 2, ',', ' ') ?> €
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <!-- RÉSUMÉ -->
                    <div class="lg:col-span-1 p-6 border-2 border-yellow-500 rounded-xl shadow-xl bg-white sticky top-24 h-fit flex flex-col justify-between">
                        <div>
                            <h3 class="font-display text-2xl text-green-800 mb-4">Résumé</h3>

                            <div class="space-y-2 mb-6">
                                <div class="flex justify-between"><span>Sous-total</span><span><?= number_format($sousTotal, 2, ',', ' ') ?> €</span></div>
                                <?php if ($reduction > 0): ?>
                                    <div class="flex justify-between text-red-600"><span>Réduction</span><span>- <?= number_format($reduction, 2, ',', ' ') ?> €</span></div>
                                <?php endif; ?>
                                <div class="flex justify-between font-bold text-green-800 border-t pt-2"><span>Total</span><span><?= number_format($total, 2, ',', ' ') ?> €</span></div>
                            </div>
                        </div>

                        <div class="space-y-3 mt-auto">
                            <form action="ajoutPanier.php" method='post'>
                                <button type="submit" name='achatPanier' class="w-full inline-block text-center bg-green-700 hover:bg-green-800 text-white rounded-lg py-3 font-semibold">
                                    Passer à la Caisse
                                </button>

                            </form>
                            <p class="text-center text-sm text-gray-500">
                                <a href="catalogue.php" class="text-yellow-600 hover:text-yellow-700">Continuer mes achats</a>
                            </p>
                        </div>
                    </div>
                </div>

            <?php else: ?>
                <div class="flex justify-center mt-16">
                    <div class="flex items-center gap-6">
                        <div class="bg-gray-200 text-gray-700 px-8 py-6 rounded-lg text-lg font-semibold">Aucun article dans le panier</div>
                        <a href="catalogue.php" class="bg-yellow-500 hover:bg-yellow-600 text-black font-semibold px-6 py-4 rounded-lg transition">Continuer mes achats</a>
                    </div>
                </div>
            <?php endif; ?>

        </div>
    </div>

    <?php include_once 'includes/footer.php'; ?>
    <?php ob_end_flush(); ?>
</body>

</html>