<?php
ob_start();
?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>

<body class="font-body bg-parchemin h-full">

    <?php include_once 'includes/header.php';
    require './connec.inc.php';
    require './includes/getRarityColor.php';
    require_once './includes/utils.php';
    require './historiqueConsultation.php';
    require './traitConsultProduit.php'; //Chargement des données

    ?>
    <!-- Message erreur/succes -->
    <?php if (isset($_GET['msgErreur']) && $_GET['msgErreur'] != null) { //Si message erreur présent on l'affiche
        afficherMessage($_GET['msgErreur'], 'erreur');
    } else if (isset($_GET['msgSucces']) && $_GET['msgSucces'] != null) { //Si message succes présent on l'affiche
        afficherMessage($_GET['msgSucces'], 'succes');
    }

    ?>

    <div id="section-consult-produit" class="w-full py-5 px-4 bg-white">
        <div class="max-w-6xl mx-auto bg-white rounded-2xl shadow-2xl overflow-y-hidden">

            <!-- En-tête -->
            <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center z-10">
                <!-- Nom de la déclinaison -->
                <h2 id="modal-product-name" class="font-display text-5xl text-green-800">
                    <?= htmlspecialchars($nom_produit) ?>
                </h2>
                <!-- Nom de la catégorie -->
                <?php
                if (!empty($categorie)) : ?>
                    <span class="text-sm font-semibold px-3 py-1 rounded-full bg-green-100 text-green-800">
                        <?= htmlspecialchars($categorie) ?>
                    </span>
                <?php else: ?>
                    <span class="text-sm font-semibold px-3 py-1 rounded-full bg-green-100 text-blue-800">
                        <?= "Aucune catégorie" ?>
                    </span>
                <?php endif; ?>
            </div>

            <!-- Contenu -->
            <div class="grid md:grid-cols-2 gap-8 p-6">
                <script src="/leroiMerlin/js/script.js" defer></script>

                <!-- Galerie images,  on charge les images grâce à la fonction chargerPhotosProduit() (dans le trait) -->
                <div>
                    <div id="modal-main-image" class="w-full h-96  rounded-lg mb-4 flex items-center justify-center shadow-lg">
                        <!-- Image principale, -->
                        <img id="main-image" src="<?php echo htmlentities($photos_produit[0])  ?>" alt="<?php echo htmlentities($nom_produit); ?>" class="w-full h-full object-cover rounded-lg" onerror="this.src='https://placehold.co/100x100/CCCCCC/FFFFFF?text=Image+manquante'" />
                    </div>
                    <!-- Si le produit a plus d'une image on charge les autres -->
                    <?php if (count($photos_produit) > 1): ?>
                        <div class="flex justify-center items-center gap-2" id="modal-image-thumbnails">
                            <!-- Autres images du produit, dans une zonne scrollable -->
                            <div class="overflow-x-auto pb-10">
                                <div class="flex justify-center gap-2 w-max">
                                    <?php foreach ($photos_produit as $photo): ?>
                                        <img src="<?php echo htmlentities($photo) ?>"
                                            class="w-20 h-20 object-cover rounded-lg cursor-pointer border border-gray-300 hover:border-green-500 transition"
                                            onclick="changeMainImage(this.src)" onerror="this.src='https://placehold.co/100x100/CCCCCC/FFFFFF?text=Image+manquante'" />

                                    <?php endforeach; ?>
                                </div>
                            </div>
                        </div>
                    <?php endif; ?>



                </div>

                <!-- Détails produit -->
                <div>
                    <div class="mb-4">
                        <span id="modal-quality-badge" class="inline-block <?php echo getRarityColor($qualite); ?> text-sm px-3 py-1 rounded-full font-semibold mb-2">
                            <?php echo $qualite; ?>
                        </span>
                        <div class="flex items-center gap-2">
                            <!-- Affichage étoiles (moyenne avis) -->
                            <div class="flex" id="modal-rating">
                                <?php
                                afficherEtoiles($moyenne);

                                ?>
                            </div>
                            <!-- Affichage de la moyenne en chiffre -->
                            <?php if (count($tab_avis) > 0): ?>
                                <span class="text-gray-600 text-sm"><?php echo "(" . $moyenne . "/5)"; ?></span>
                            <?php endif; ?>
                            <!-- Nombre d'avis -->
                            <span class="text-gray-600 text-sm"><?php echo count($tab_avis) . " avis"; ?></span>

                        </div>
                    </div>
                    <!--Prix et Variantes-->
                    <div class="mb-4">
                        <div class="flex items-center justify-start gap-6">
                            <!-- PRIX À GAUCHE -->
                            <div class="flex items-center gap-3 flex-shrink-0">
                                <!--Prix soldé et ancien prix-->
                                <?php if ($infos_produit['prixSolde'] !== null): ?>
                                    <span class="text-3xl text-red-700 line-through mr-2"><?= $infos_produit['prix'] ?> €</span>
                                    <span class="text-3xl text-green-700 font-bold "><?php echo "{$infos_produit['prixSolde']}€"; ?></span>
                                    <!--Prix hors soldes-->
                                <?php else : ?>
                                    <span class="text-3xl text-green-700 font-bold"><?php echo "{$infos_produit['prix']}€"; ?></span>
                                <?php endif; ?>
                            </div>

                            <!-- VARIANTES À DROITE -->
                            <?php if (!empty($tab_variantes)): ?>
                                <div class="flex items-center gap-3 w-full overflow-x-auto overflow-y-hidden">
                                    <span class="text-xs text-gray-500 font-semibold whitespace-nowrap">Autres versions :</span>

                                    <!-- Conteneur scrollable limité à la largeur de la colonne -->
                                    <div class="w-full max-w-full overflow-x-auto overflow-y-visible pb-3 pr-2 flex items-center">
                                        <div class="inline-flex gap-2 flex-nowrap">
                                            <?php foreach ($tab_variantes as $variante):
                                                $images_variantes = chargerPhotosProduit($variante['idDeclinaison'], $variante['libelleDeclinaison']);
                                            ?>
                                                <a href="consultProduit.php?id=<?= $variante['idDeclinaison']; ?>"
                                                    class="group relative flex-shrink-0"
                                                    title="<?= $variante['libelleDeclinaison']; ?>">
                                                    <div class="w-12 h-12 rounded-lg overflow-hidden border-2 border-gray-300 group-hover:border-green-500 transition-all  origin-bottom shadow-sm">
                                                        <img src="<?= htmlentities($images_variantes[0]); ?>"
                                                            alt="<?= htmlentities($variante['libelleDeclinaison']); ?>"
                                                            class="w-full h-full object-cover"
                                                            onerror="this.src='https://placehold.co/100x100/CCCCCC/FFFFFF?text=Image+Introuvable'">
                                                    </div>


                                                </a>
                                            <?php endforeach; ?>
                                        </div>
                                    </div>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>


                    <!-- Description -->
                    <div class="mb-6">
                        <h3 class="font-semibold text-lg mb-2">Description</h3>
                        <p class="text-gray-600 leading-relaxed" id="modal-description">
                            <?php echo htmlentities("{$description}"); ?>
                        </p>
                    </div>
                    <!-- Fiche technique -->
                    <div class="mb-6">
                        <h3 class="font-semibold text-lg mb-3">Caractéristiques Techniques</h3>
                        <ul class="space-y-2 text-gray-600" id="modal-specs">
                            <!-- Specs -->
                            <?php echo htmlentities("{$ficheTechnique}"); ?>
                        </ul>
                    </div>
                    <!-- Provenance -->
                    <div class="mb-6">
                        <h3 class="font-semibold text-lg mb-2">Provenance</h3>
                        <p class="text-gray-600">
                            <?php echo htmlentities("{$provenance}"); ?>
                        </p>
                    </div>
                    <!-- Regroupements, si il y en a -->
                    <?php if (!empty($regroupements)): ?>
                        <div class="mb-6">
                            <h3 class="font-semibold text-lg mb-3 text-gray-800">
                                Apparaît dans
                            </h3>
                            <div class="flex flex-wrap gap-2">
                                <!-- Affiche 3 regroupements au max-->
                                <?php foreach ($regroupements_a_afficher as $re): ?>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full 
                                    bg-blue-100 text-blue-800 text-sm font-medium">
                                        <?= htmlspecialchars($re) ?>
                                    </span>
                                <?php endforeach; ?>
                                <!-- On affiche le nombre de regroupements qu'il reste (ceux qui sont pas visibles)-->
                                <?php if (count($regroupements) > 3): ?>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full 
                             bg-gray-100 text-gray-600 text-sm font-medium">
                                        +<?= $nb_regroupement_restants ?>
                                    </span>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endif; ?>

                    <div class="mb-4 p-4 rounded-lg border bg-white shadow-sm">
                        <!-- Stock restant -->
                        <h3 class="font-semibold text-lg mb-2 text-gray-800">
                            Quantité disponible
                        </h3>
                        <p class="text-xl font-bold
                            <?php echo ($qte_stock > 0) ? 'text-green-600' : 'text-red-600'; ?>">
                            <?php
                            if ($qte_stock > 0) {
                                echo $qte_stock . " en stock";
                            } else {
                                echo "Hors stock";
                            }
                            ?>
                        </p>
                    </div>
                    <!-- Affichage seulement si la qte en stock est >= 0 -->
                    <?php if ($qte_stock > 0): ?>
                        <form method="POST" action="ajoutPanier.php">
                            <div class="flex items-center gap-4 mb-6">
                                <label class="font-semibold text-gray-700">Quantité :</label>
                                <div class="flex items-center">
                                    <input type="number" name="qte" value="1" min="1" max="<?php echo $infos_produit['qteStock'] ?>"
                                        class="w-20 text-center text-lg font-semibold border-2 border-green-700 rounded-lg py-2 px-3 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-all">
                                </div>
                            </div>
                            <input type="hidden" name="origine" value="consultProduit">
                            <input type="hidden" name="idProduit" value="<?= $infos_produit['idDeclinaison'] ?>">
                            <div class="flex gap-4 mb-6">
                                <button type="submit" name="panier"
                                    class="flex-1 bg-green-700 hover:bg-green-800 text-white rounded-lg py-3 font-semibold transition-all transform hover:scale-105">
                                    Ajouter au panier
                                </button>
                                <button type="submit" value="achat" name="achat"
                                    class="flex-1 bg-yellow-500 hover:bg-yellow-600 text-green-900 rounded-lg py-3 font-semibold transition-all transform hover:scale-105">
                                    Acheter maintenant
                                </button>
                            </div>
                        </form>
                    <?php endif; ?>


                </div>
            </div>
            <!-- Si le produit est un kit on affiche les produits contenus dans le kit -->
            <?php if (!empty($produits_contenus_kit)): ?>
                <div class="p-5 rounded-lg border bg-green-50 shadow-sm">
                    <h3 class="font-semibold text-lg mb-3 text-green-900">
                        Contenu du kit
                    </h3>
                    <!--liste de chaque produit du kit -->
                    <ul class="space-y-2">
                        <?php foreach ($produits_contenus_kit as $item): ?>
                           
                            <li >
                             <a href="consultProduit.php?id=<?php echo $item['idDeclinaison']?>" class="flex items-center justify-between bg-white rounded-lg px-4 py-2 border border-green-200">    
                                <span class="text-gray-800 font-medium">
                                    <?= htmlspecialchars($item['libelle']) ?>
                                </span>
                                <span class="text-sm font-semibold text-green-700 bg-green-100 px-3 py-1 rounded-full">
                                    × <?= (int) $item['quantite'] ?>
                                </span>
                                </a>
                            </li>
                            
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>


            <!-- Section Avis -->
            <div class="border-t px-6 py-8 bg-gray-50">
                <h3 class="font-display text-2xl text-green-800 mb-6">Avis des Aventuriers</h3>
                <div class="space-y-4 mb-8" id="reviews-list">
                    <?php if (!empty($tab_avis)): //Si des avis sont trouvés
                    ?>
                        <!-- Pour chaque avis Avis -->
                        <?php foreach ($tab_avis as $avis) : ?>
                            <!-- Boite Avis -->

                            <div class="bg-white p-4 rounded-lg shadow-md">
                                <div class="flex items-center justify-between mb-2">
                                    <span class="font-semibold text-green-800"><?php echo htmlspecialchars("{$avis['nom']} {$avis['prenom']}"); ?></span>
                                    <span class="text-gray-500 text-sm"><?php echo "{$avis['dateAvis']}"; ?></span>
                                </div>
                                <div class="flex gap-1 mb-2">
                                    <?php afficherEtoiles($avis['note']); //Affichage du bon nombre d'étoiles 
                                    ?>

                                </div>
                                <!-- Commentaire client -->
                                <p class="text-gray-800 leading-relaxed mb-3">
                                    <?= htmlspecialchars($avis['commentaire'] ?? '', ENT_QUOTES, 'UTF-8'); //Si l'avis est vide, on affiche une chaine vide
                                    ?>
                                </p>
                                <!-- Si l'avis a des images on les charge -->
                                <?php
                                // On essaie de récupérer les photos
                                $photos_avis = chargerPhotosAvis($avis['idAvis']);

                                // Si il y a des photos présentes
                                if (!empty($photos_avis)) : ?>
                                    <!-- Images de l'avis -->
                                    <div class="mt-3">
                                        <!-- Conteneur flex pour les images -->
                                        <div class="flex flex-wrap gap-4 justify-start">
                                            <!-- Boucle sur chaque image -->
                                            <?php foreach ($photos_avis as $photo) : ?>
                                                <!-- Image de review plus grande -->
                                                <div class="w-36 h-36 md:w-48 md:h-48 overflow-hidden rounded-lg border border-gray-300 hover:border-green-500 transition cursor-pointer">
                                                    <img src="<?= htmlspecialchars($photo) ?>"
                                                        alt="Photo de l'avis"
                                                        class="object-contain w-full h-full"
                                                        onerror="this.src='https://placehold.co/250x250/CCCCCC/FFFFFF?text=Image+manquante';" />
                                                </div>
                                            <?php endforeach; ?>
                                        </div>
                                    </div>
                                <?php endif; ?>


                                <?php $tab_reponses = chargerReponsesAvis($avis['idAvis']); //Charger les réponses de l'avis
                                ?>

                                <?php if (!empty($tab_reponses)) :  //Si une ou des réponses sont
                                ?>
                                    <!-- Boite Réponse Avis -->
                                    <div class="mt-4 bg-gray-50 border border-green-700/30 rounded-xl p-4 shadow-sm">

                                        <!-- En-tête -->
                                        <div class="flex items-center gap-2 mb-3">
                                            <span class="text-green-800 font-bold text-lg">
                                                Réponse de LeRoi Merlin
                                            </span>
                                            <span class="text-green-600 text-xl">🪄</span>
                                        </div>

                                        <!-- Liste des réponses des admins-->
                                        <div class="space-y-2">
                                            <?php foreach ($tab_reponses as $reponse) : ?>
                                                <div class="p-3 bg-white rounded-lg border border-green-200 shadow-sm">
                                                    <p class="text-sm text-gray-900">
                                                        <span class="font-semibold text-green-700">
                                                            <?= htmlspecialchars($reponse['nomAdmin'] . ' ' . $reponse['prenomAdmin']); ?>
                                                        </span>
                                                        :
                                                        <?= htmlspecialchars($reponse['reponse']); ?>
                                                    </p>
                                                </div>
                                            <?php endforeach; ?>
                                        </div>
                                    </div>
                                <?php endif; ?>
                            </div>

                        <?php endforeach; ?>


                    <?php else : ?>
                        <p class="text-gray-600 italic">Aucun avis pour ce produit…</p>
                    <?php endif; ?>
                </div>

                <!-- Formulaire d'avis //Seulement si l'utilisateur est connecté + a acheté le produit-->
                <?php if (isset($_SESSION["idClient"]) && isAvisAutorise($_SESSION["idClient"], $idProduit) == true): ?>
                    <div class="bg-white p-6 rounded-lg shadow-md">
                        <h4 class="font-semibold text-lg mb-4">Laisser un avis</h4>
                        <form id="review-form" method="post" action="traitAvis.php" enctype="multipart/form-data">

                            <input type="hidden" name="idProduit" value="<?= $infos_produit['idDeclinaison'] ?>">
                            <div class="mb-4">
                                <div class="mb-4">
                                    <label for="review-note" class="block font-semibold mb-2">
                                        Note (entre 0 et 5) :
                                    </label>

                                    <input
                                        type="number"
                                        id="review-note"
                                        name="note"
                                        min="0"
                                        max="5"
                                        step="1"
                                        required
                                        class="w-24 px-4 py-2 border-2 border-gray-300 rounded-lg text-center text-lg
                                        focus:outline-none focus:border-green-700"
                                        placeholder="5" />
                                </div>
                            </div>
                            <div class="mb-4">
                                <label for="review-text" class="block font-semibold mb-2">Votre avis (optionnel):</label>
                                <textarea id="review-text" name="commentaire" rows="4" class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700" placeholder="Partagez votre expérience..."></textarea>
                            </div>
                            <div class="mb-4">
                                <label for="review-image" class="block font-semibold mb-2">Ajouter des images (optionnel, 4 max) :</label>
                                <input type="file" id="review-image" name="imageMedia[]"
                                    accept="image/jpeg,image/png" class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg" multiple>
                            </div>
                            <button type="submit" name="envoiAvis" class="bg-green-700 hover:bg-green-800 text-white px-6 py-3 rounded-lg font-semibold transition-all transform hover:scale-105">
                                Publier l'avis
                            </button>
                        </form>
                    </div>
                <?php endif; ?>
            </div>

            <!-- Produits apparentés -->
            <?php if (!empty($tab_produitsSimilaires)) : ?>
                <div class="border-t px-6 py-8 bg-white">
                    <h3 class=" font-display text-2xl text-green-800 mb-6">Artefacts Similaires</h3>
                    <div class="relative overflow-x-auto pb-6 overflow-y-hidden  ">
                        <div
                            id="related-carousel" class="flex flex-nowrap gap-4">
                            <?php
                            //Pour chaque produit apparenté
                            foreach ($tab_produitsSimilaires as $produit) :
                                //Récup les photos du produit apparenté
                                $photos_produits_similaires = chargerPhotosProduit($produit['idDeclinaison'], $produit['libelleDeclinaison']);
                                genererVignetteProduit(
                                    $produit['idDeclinaison'],
                                    $produit['libelleDeclinaison'],
                                    $produit['prix'],
                                    $produit['prixSolde'],
                                    $produit['qualite'],
                                    $produit['libelle'],
                                    'petite'
                                );
                            ?>

                            <?php endforeach; ?>
                        </div>

                    </div>
                </div>
            <?php endif; ?>
        </div>
    </div>
</body>
<?php include_once 'includes/footer.php'; ?>
<?php ob_end_flush(); ?>