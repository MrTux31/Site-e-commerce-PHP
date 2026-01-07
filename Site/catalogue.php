<?php
ob_start();
?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>

<body class="font-body bg-parchemin h-full">

    <?php include_once 'includes/header.php'; ?>
    <?php require 'connec.inc.php';
    require './includes/getRarityColor.php';
    require_once './includes/utils.php';
    require './traitCatalogue.php';
    ?>
     <!-- Message erreur/succes -->
    <?php if (isset($_GET['msgErreur'])) { //Si message erreur présent on l'affiche
        afficherMessage($_GET['msgErreur'], 'erreur');
    } else if (isset($_GET['msgSucces'])) { //Si message succes présent on l'affiche
        afficherMessage($_GET['msgSucces'], 'succes');
    }

    ?>
    <div id="section-produits" class="section-content w-full py-16 px-4 bg-white">
        <div class="max-w-7xl mx-auto">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <h2 class="font-display text-4xl text-green-800">Catalogue        </h2>
                <div class="flex flex-wrap gap-3">
                    <!--FORMULAIRE TRI------>
                    <form method="GET" action="" class="flex flex-wrap gap-3">
                        <!--INCLUSION DE LA RECHERECHE TEXTE------>
                        <input type="hidden" name="search" value="<?php echo htmlentities($search) ?>">

                        <!--GESTION DE LA QUALITE------>
                        <select name="quality" class="px-4 py-2 border-2 border-green-700 rounded-lg focus:outline-none focus:border-yellow-500" onchange="this.form.submit()">
                            <?php
                            $selcted_quality = $quality ?? ''; //On la récup la qualité si elle existe, sinon on met chaine vide
                            echo '<option value="all" selected >Toutes qualités</option>'; //Option par défaut
                            foreach ($qualites as $qualite) { //Parcours de toutes les qualités disponibles
                                $selected = ($selcted_quality == $qualite ? 'selected' : ''); //Si la qualité sélectionnée est la meme que la qualite actuelle, on met 'selected'
                                $selected = htmlentities($selected);
                                
                                $qualite = htmlentities($qualite);
                                echo '<option value="' . $qualite . '"' . $selected . '>' . $qualite . '</option>'; //On injecte dans une option la qualité et si elle est selectionnée select auto
                            }
                            ?>
                        </select>

                        <!--GESTION DES REGROUPEMENTS------>
                        <select name="regroupement" class="px-4 py-2 border-2 border-green-700 rounded-lg focus:outline-none focus:border-yellow-500" onchange="this.form.submit()">
                            <?php
                            $selcted_regroupement = $regroupement ?? ''; //On la récup le regroupement si il existe, sinon on met chaine vide
                            echo '<option value="all" selected >Aucun tri Regroupement</option>'; //Option par défaut
                            foreach ($regroupements as $id => $libelle) { //Parcours de tous les regroupements disponibles
                                $selected = ($selcted_regroupement == $id ? 'selected' : ''); //Si le regroupement sélectionné est le meme que la regroupement actuel, on met 'selected'
                                $selected = htmlentities($selected);

                                $id = htmlentities($id);
                                $libelle = htmlentities($libelle);
                                echo  '<option value="' . $id . '"' . $selected . '>' . $libelle . '</option>'; //On injecte dans une option le regroupement et si elle est selectionnée select auto
                            }
                            ?>
                        </select>
                        <!--GESTION DES CATEGORIES------>
                        <select name="category" class="px-4 py-2 border-2 border-green-700 rounded-lg focus:outline-none focus:border-yellow-500" onchange="this.form.submit()">
                            <?php
                            $selected_category = $category ?? ''; //On la récup la catégorie si elle existe, sinon on met chaine vide
                            echo '<option value="all" selected>Toutes les catégories</option>'; //Option par défaut
                            foreach ($categories as $id => $libelle) { //Parcours de toutes les catégories disponibles
                                $selected = ($selected_category == $id ? 'selected' : ''); //Si la catégorie sélectionnée est la meme que la catégorie actuelle, on met 'selected'
                                $selected = htmlentities($selected);

                                $id = htmlentities($id);
                                $libelle = htmlentities($libelle);
                                echo '<option value="' . $id . '"' . $selected . '>' . $libelle . '</option>'; //On injecte dans une option la catégorie et si elle est selectionnée select auto
                            }
                            ?>
                        </select>
                        <!--GESTION DES SOUS-CATEGORIES------>

                        <?php if (!empty($selected_category) && $selected_category != "all") { ?>

                            <select name="sub-category" class="px-4 py-2 border-2 border-green-700 rounded-lg focus:outline-none focus:border-yellow-500" onchange="this.form.submit()">
                                <?php
                                $selected_sub_category = $subCategory ?? ''; //On la récup la sous-catégorie si elle existe, sinon on met chaine vide
                                echo '<option value="all">Toutes les sous-catégories</option>'; //Option par défaut
                                $sous_categories = chargerCategoriesEnfants($selected_category); //On récupère TOUTES les sous categs
                                if (!empty($sous_categories)) {
                                    foreach ($sous_categories as $id => $libelle) { //Parcours de toutes les sous catégories disponibles
                                        $selected = ($selected_sub_category == $id ? 'selected' : ''); //Si la sous catégorie sélectionnée est la meme que la catégorie actuelle, on met 'selected'
                                        $selected = htmlentities($selected);

                                        $id = htmlentities($id);
                                        $libelle = htmlentities($libelle);
                                        echo '<option value="' . $id . '"' . $selected . '>' . $libelle . '</option>'; //On injecte dans une option la catégorie et si elle est selectionnée select auto
                                    }
                                }
                                ?>
                            </select>
                        <?php } ?>




                        <!--GESTION DES TRIS PRIX------>
                        <select name="sort" class="px-4 py-2 border-2 border-green-700 rounded-lg focus:outline-none focus:border-yellow-500" onchange="this.form.submit()">
                            <option value="">Aucun tri de prix</option>
                            <option value="price-asc" <?= ($sort ?? '') === 'price-asc' ? 'selected' : '' ?>>Prix croissant</option>
                            <option value="price-desc" <?= ($sort ?? '') === 'price-desc' ? 'selected' : '' ?>>Prix décroissant</option>
                        </select>
                    </form>

                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6 min-h-[30vh] " id="all-products">

                <!-- ---------------------------------------------------- -->
                <!--  DÉBUT DE BOUCLE DU CATALOGUE COMPLET -->
                <!-- ---------------------------------------------------- -->

                <?php //Chargement des produits correspondants aux critères de recherche
                
                if (!empty($produits)) { //Si des produits sont trouvés
                    foreach ($produits as $cle => $produit) { 
                        genererVignetteProduit($produit['idDeclinaison'],$produit['libelleDeclinaison'], $produit['prix'], $produit['prixSolde'], $produit['qualite'], $produit['produit_libelle']);?>
                    <?php }
                } else { // Aucun produit trouvé 
                    ?>
                    <p class="mt-8 text-center text-gray-500 text-lg col-span-full w-full">
                    Aucun produit ne correspond à votre recherche.
                </p>
                <?php } ?>
            </div>
        </div>
    </div>

  

    <?php include_once 'includes/footer.php'; ?>
    <?php ob_end_flush(); ?>
