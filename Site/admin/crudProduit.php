<?php
session_start();
// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

require "../connec.inc.php";
require_once "./chargementDonneesProduit.php";
require_once "../includes/getRarityColor.php";
require_once "../includes/utils.php";
require_once("./traitProduitParent.php");
require_once("./traitDeclinaisonProduit.php");

//RECEPTION DES FORMULAIRES


//Action sur un produit parent
if (isset($_POST['action_parent'])) {
    $resultat = traiterProduitParent($_POST);
    //Erreur
    if ($resultat != 'insert' && $resultat != 'update') {
        redirectWithMessage($resultat, 'Erreur');
    }
    //Succès
    if ($resultat == 'insert') {
        redirectWithMessage("Produit ajouté avec succès.");
    } else {
        redirectWithMessage("Produit mis à jour avec succès.");
    }
}
//Actions sur une déclinaison
else if (isset($_POST['action_declinaison'])) {
    $resultat = traiterDeclinaison($_POST);
    //Erreur
    if ($resultat != 'insert' && $resultat != 'update') {
        redirectWithMessage($resultat, 'Erreur');
    }
    //Succès
    if ($resultat == 'insert') {
        redirectWithMessage("Déclinaison ajoutée avec succès.");
    } else {
        redirectWithMessage("Déclinaison mise à jour avec succès.");
    }
}


?>
<!doctype html>
<html lang="fr" class="h-full">
<link rel="stylesheet" href="../css/styleAdmin.css">

<?php
include_once '../includes/head.php';

?>


<body class="font-body bg-parchemin-admin h-full flex overflow-hidden">
    <?php
    include_once __DIR__ . '/../includes/navAdmin.php';;

    ?>

    <main class="flex-1 flex flex-col h-full overflow-auto relative z-10">

        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8 shadow-sm">
            <h2 class="text-2xl font-display font-bold text-green-900">Le Grimoire (Produits)</h2>
            <!--Bouton pour ajouter un nouveau produit--->
            <button onclick="openModalParent()" class="bg-[#1A4D2E] text-yellow-400 px-4 py-2 rounded border border-yellow-500 hover:bg-green-800 transition shadow-md flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                </svg>
                Créer un Produit (Parent)
            </button>
        </header>




        <div class="flex-1 overflow-y-auto p-8">
            <!-- Message erreur/succes -->
            <?php if (isset($_GET['msgErreur'])) { ?>
                <div class="bg-red-50 border border-red-400 text-red-800 text-center rounded-xl p-4 mb-6 shadow">
                    <?= htmlspecialchars($_GET['msgErreur']) ?>
                </div>

            <?php } else if (isset($_GET['msgSucces'])) { ?>
                <div class="bg-green-50 border border-green-400 text-green-800 text-center rounded-xl p-4 mb-6 shadow">
                    <?= htmlspecialchars($_GET['msgSucces']) ?>
                </div>
            <?php } ?>

            <!--Si au moins 1 produit est trouvé--->
            <?php if (count($tab_produits) > 0): ?>
                <!--Tableau contenant chaque produit--->
                <table class="w-full bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg overflow-hidden">
                    <!--Nom des colonnes du tableau-->
                    <thead class="bg-[#1A4D2E] text-yellow-400 font-bold text-xs uppercase tracking-wider">
                        <tr>
                            <th class="px-6 py-3 text-left">ID</th>
                            <th class="px-6 py-3 text-left">Nom du Produit (Abstrait)</th>
                            <th class="px-6 py-3 text-left">Catégorie</th>
                            <th class="px-6 py-3 text-center">Variantes</th>
                            <th class="px-6 py-3 text-center">Action</th>

                        </tr>
                    </thead>

                    <tbody>
                        <!--Pour chaque produit existant--->
                        <?php foreach ($tab_produits as $prod): ?>
                            <!--Zone d'un produit dans le tableau-->
                            <!--Gestion zone click pour afficher sous menu variantes-->
                            <tr class="border-b border-yellow-600/10 hover:bg-yellow-50 cursor-pointer"
                                onclick="toggleVariantes('prod-<?php echo htmlentities($prod['idProduit']); ?>')">

                                <!--ID du produit-->
                                <td class="px-6 py-4 font-mono text-gray-500 text-sm">
                                    #<?php echo $prod['idProduit']; ?>
                                </td>

                                <!--Nom du produit-->
                                <td class="px-6 py-4">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 rounded-full bg-yellow-100 flex items-center justify-center mr-3 border border-yellow-200">
                                            <!--Flèche déroulante-->
                                            <svg id="icon-prod-<?php echo $prod['idProduit']; ?>"
                                                class="w-5 h-5 text-yellow-700 chevron transition-transform"
                                                fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M9 5l7 7-7 7"></path>
                                            </svg>
                                        </div>
                                        <!--Libelle du produit-->
                                        <span class="font-bold text-xl text-green-900 group-hover:text-green-700">
                                            <?php echo htmlentities($prod['libelle']); ?>
                                        </span>
                                    </div>
                                </td>

                                <!--Catégorie du produit-->
                                <td class="px-6 py-4">
                                    <span class="bg-indigo-100 text-indigo-800 text-xs font-semibold px-2.5 py-0.5 rounded border border-indigo-200 uppercase tracking-wide">
                                        <!--Si le produit a une catégorie-->
                                        <?php
                                        if (!empty($prod['categorie_libelle'])) {
                                            echo htmlentities($prod['categorie_libelle']);
                                        } else { //Le produit n'a pas de catégorie
                                            echo "Aucune catégorie";
                                        }
                                        ?>
                                    </span>
                                </td>

                                <!--Nombre de déclinaisons-->
                                <td class="px-6 py-4 text-center">
                                    <span class="bg-gray-100 text-gray-700 text-sm font-bold px-3 py-1 rounded-full border border-gray-300">
                                        <?php echo count($prod['variantes']); ?> déclinaisons
                                    </span>
                                </td>

                                <!--Boutons d'édition et suppression du produit parent-->
                                <td class="px-6 py-4 text-center">
                                    <!--On définit sur "onClick" l'appel de la fonction JS permettant d'éditer le produit-->
                                    <button onclick='editParent(<?= json_encode($prod, JSON_HEX_APOS | JSON_HEX_QUOT); ?>)' class="btn-text-action btn-text-edit">Modifier</button>
                                </td>
                            </tr>

                            <!--Menu déroulant pour le produit-->
                            <tr id="prod-<?php echo $prod['idProduit']; ?>" class="hidden-row">
                                <td colspan="5" class="bg-yellow-50/50 shadow-inner p-4">
                                    <!--On génère le tableau des déclinaisons si au moins une est présente-->
                                    <?php 
                                    if (count($prod['variantes']) > 0): ?>
                                        <!--Tableau pour contenir les déclinaisons du produit-->
                                        <div class="overflow-x-auto">
                                            <table class="table-auto w-full border-collapse text-center align-middle">
                                                <!--En tete du tableau-->
                                                <thead class="bg-yellow-50 text-xs font-bold text-gray-500 uppercase">
                                                    <tr>
                                                        <!--ID de la déclinaison-->
                                                        <th class="p-2 border-b">ID</th>
                                                        <!--Libelle de la déclinaison-->
                                                        <th class="p-2 border-b">Déclinaison</th>
                                                        <!--Prix standard de la déclinaison-->
                                                        <th class="p-2 border-b">Prix Standard</th>
                                                        <!--Prix soldé de la déclinaison-->
                                                        <th class="p-2 border-b">Prix Soldé</th>
                                                        <!--Stock de la déclinaison-->
                                                        <th class="p-2 border-b">Stock</th>
                                                        <!--Qualité de la déclinaison-->
                                                        <th class="p-2 border-b">Qualité</th>
                                                        <!--Actions pour la déclinaison-->
                                                        <th class="p-2 border-b text-right">Action</th>
                                                    </tr>
                                                </thead>
                                                <!--Contenu du tableau-->
                                                <tbody>
                                                    <!--Pour chaque déclinaisons du produit, on ajoute une ligne-->
                                                    <?php foreach ($prod['variantes'] as $declinaison): ?>
                                                        <!--Ligne de la déclinaison-->
                                                        <tr class="hover:bg-yellow-100">
                                                            <!--ID de la déclinaison-->
                                                            <td class="p-2 font-mono text-xs text-gray-400 align-middle">#<?= htmlentities($declinaison['idDeclinaison']); ?></td>
                                                            <!--Libelle de la déclinaison-->
                                                            <td class="p-2 font-medium text-green-900 align-middle"><?= htmlentities($declinaison['libelleDeclinaison']); ?></td>
                                                            <!--Prix standard de la déclinaison-->
                                                            <td class="p-2 font-bold text-green-800 align-middle"><?= number_format($declinaison['prix'], 2); ?>€</td>
                                                            <!--Prix soldé de la déclinaison, si soldé affiche le prix vert, sinon non soldé en gris-->
                                                            <td class="p-2 font-bold <?php echo $declinaison['prixSolde'] !== null ? 'text-green-800 align-middle' : 'text-gray-500 align-middle'; ?>">
                                                                <?= $declinaison['prixSolde'] !== null ? number_format($declinaison['prixSolde'], 2) . '€' : 'Non soldé'; ?>
                                                            </td>
                                                            <!--Stock de la déclinaison-->
                                                            <td class="p-2 align-middle">
                                                                <!--Si la qte en stock est <= au seuil de qte alerte, alors on affiche le stock en rouge sinon en vert-->
                                                                <span class="<?= $declinaison['qteStock'] <= $declinaison['seuilQte'] ? 'text-red-600 font-bold bg-red-50 px-2 py-1 rounded' : 'text-green-700'; ?>">
                                                                    <?= $declinaison['qteStock']; ?>
                                                                </span>
                                                            </td>
                                                            <!--Qualité de la déclinaison-->
                                                            <td class="p-2 align-middle">
                                                                <span class="<?= getRarityColor($declinaison['qualite']); ?> px-2 py-0.5 text-xs rounded-full"><?= $declinaison['qualite']; ?></span>
                                                            </td>
                                                            <!--Boutons d'édition de la déclinaison-->
                                                            <td class="p-2 text-right flex justify-end gap-2 align-middle">
                                                                <!--On définit sur "onClick" l'appel de la fonction JS permettant d'éditer la déclinaison-->
                                                                <button onclick='editVariante(<?= json_encode($declinaison, JSON_HEX_APOS | JSON_HEX_QUOT); ?>)' class="btn-text-action btn-text-edit">Modifier</button>
                                                            </td>
                                                        </tr>
                                                    <?php endforeach; ?>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!--Si aucune déclinaison n'est existante pour le produit-->
                                    <?php else : ?>
                                        <div class="p-8 text-center text-gray-500">
                                            Aucune déclinaison existante !
                                        </div>
                                    <?php endif; ?>
                                    <!--Bouton d'ajout d'une déclinaison du produit-->
                                    <div class="mt-3 pt-3 border-t border-yellow-200 flex justify-center">
                                        <button onclick="openModalVariante(<?php echo $prod['idProduit']; ?>)" class="flex items-center text-sm text-green-700 hover:text-green-900 font-semibold bg-green-50 px-4 py-2 rounded-full border border-green-200 hover:bg-green-100 transition">
                                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                            </svg>
                                            Ajouter une déclinaison
                                        </button>
                                    </div>

                                </td>
                            </tr>
                        <?php endforeach; ?>

                </table>
            <?php else : ?>
                <div class="p-8 text-center text-gray-500">
                    Aucun produit disponible !
                </div>
            <?php endif; ?>
        </div>


    </main>

    <!--Fenetre de création / d'édition d'un produit parent, initialement cachée-->
    <div id="modalParent" class="fixed inset-0 bg-black/60 hidden z-50 items-center justify-center p-4 backdrop-blur-sm overflow-auto">
        <div class="modal-magique w-full max-w-2xl max-h-[90vh] rounded-lg overflow-y-auto relative animate-fade-in-up">
            <div class="bg-[#FAF9F0] p-6 border-b border-yellow-600/20 flex justify-between items-center">
                <h3 id="titreParent" class="text-xl font-display font-bold text-green-900"></h3>
                <button onclick="closeModal('modalParent')" class="text-gray-500 hover:text-red-600"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg></button>
            </div>

            <div class="p-6 bg-[#F5F5DC]">
                <!--Formulaire de création du produit-->
                <form id="formParent" method="POST">
                    <!--Nom de l'action en POST-->
                    <input type="hidden" name="action_parent" value="1">
                    <!--id du produit-->
                    <input type="hidden" name="idProduit" id="idProduit">

                    <div class="mb-4">
                        <label class="block text-green-900 font-bold mb-1">Nom du Produit (Concept)</label>
                        <input type="text" name="nomProduit" id="nomProduit" required class="input-forge" placeholder="Ex: Potion de Vitesse">
                    </div>

                    <!--Description du produit--->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Description</label>
                        <textarea name="descriptionProduit" id="descriptionProduit" required class="input-forge" placeholder="Ex: Régénère une grande quantité de mana (100%)"></textarea>
                    </div>

                    <div class="mb-4">
                        <!--Catégories disponibles-->
                        <label class="block text-green-900 font-bold mb-1">Catégorie</label>
                        <select name="categorie" id="categorie" class="input-forge">
                            <?php
                            //value du select : id de la catégorie
                            echo '<option value = "" >Aucune catégorie</option>';
                            foreach ($tab_categories as $categorie): ?>
                                <option value="<?= htmlentities($categorie['idCategorie']) ?>"><?= htmlentities($categorie['libelle']) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <!--Boutons de sauvegarde et annulation-->
                    <div class="flex justify-end gap-3 mt-6">
                        <button type="button" onclick="closeModal('modalParent')" class="px-4 py-2 border border-green-800 text-green-800 rounded">Annuler</button>
                        <button type="submit" class="px-6 py-2 bg-[#1A4D2E] text-yellow-400 font-bold rounded border-2 border-yellow-500 shadow-lg">Enregistrer Produit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!--Fenetre de création / d'édition d'une déclinaison, itialement cachée-->
    <div id="modalVariante" class="fixed inset-0 bg-black/60 hidden z-50 items-center justify-center p-4 backdrop-blur-sm overflow-auto">
        <div class="modal-magique w-full max-w-2xl max-h-[90vh] rounded-lg overflow-y-auto relative animate-fade-in-up">
            <div class="bg-[#FAF9F0] p-6 border-b border-yellow-600/20 flex justify-between items-center">
                <h3 id="titleVariante" class="text-xl font-display font-bold text-green-900"></h3>
                <!--Fermeture de ma fenetre-->
                <button onclick="closeModal('modalVariante')" class="text-gray-500 hover:text-red-600"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg></button>
            </div>
            <div class="p-6 bg-[#F5F5DC]">
                <!--Formulaire d'infos de la déclinaison-->
                <form id="formVariante" method="POST" enctype="multipart/form-data" class="grid grid-cols-2 gap-4">
                    <input type="hidden" name="action_declinaison" value="1">
                    <!--ID du produit parent, injecté par JS--->
                    <input type="hidden" name="idProduitParent" id="idParentForVar">
                    <!--ID de la déclinaison, injecté par JS--->
                    <input type="hidden" name="idDeclinaison" id="idVar">
                    <!--Libelle déclinaison--->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Nom de la déclinaison</label>
                        <input type="text" name="libelleDeclinaison" id="libelleVar" required class="input-forge" placeholder="Ex: Fiole 50ml">
                    </div>
                    <!--Description de la déclinaison--->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Description</label>
                        <textarea name="descriptionDeclinaison" id="descriptionDeclinaison" required class="input-forge" placeholder="Ex: Régénère une grande quantité de mana (100%)"></textarea>
                    </div>
                    <!--Fiche technique de la déclinaison--->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Fiche technique</label>
                        <textarea name="ficheTechniqueDeclinaison" id="ficheTechniqueDeclinaison" required class="input-forge" placeholder="Ex: Contenance: 200ml, Effet: Instantané, Poids: 0.3kg"></textarea>
                    </div>
                    <!--Provenance de la déclinaison--->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Provenance</label>
                        <input type="text" name="provenance" id="provenanceDeclinaison" required class="input-forge" placeholder="Ex: Falconia">
                    </div>
                    <!--Prix déclinaison--->
                    <div>
                        <label class="block text-green-900 font-bold mb-1">Prix </label>
                        <input type="number" step="0.01" min="0" name="prix" id="prixVar" required class="input-forge">
                    </div>
                    <!--Prix soldé (vide pour hors-solde)--->
                    <div>
                        <label class="block text-green-900 font-bold mb-1">Prix soldé (vide pour hors-solde) </label>
                        <input type="number" step="0.01" min="0" name="prixSolde" id="prixSoldeDeclinaison" class="input-forge">
                    </div>
                    <!--Stock de la déclinaison--->
                    <div>
                        <label class="block text-green-900 font-bold mb-1">Quantité en stock</label>
                        <input type="number" name="qteStock" min="0" id="stockVar" required class="input-forge">
                    </div>
                    <!--Qualité de la déclinaison--->
                    <div>
                        <label class="block text-green-900 font-bold mb-1">Qualité</label>
                        <select name="qualite" id="qualiteVar" class="input-forge" required>
                            <?php 
                            foreach ($tab_qualites as $qualite): ?>
                                <option value="<?= htmlspecialchars($qualite) ?>"><?= htmlspecialchars($qualite) ?></option>
                            <?php endforeach; ?>

                        </select>
                    </div>
                    <!--Seuil d'alerte de la déclinaison--->
                    <div>
                        <label class="block text-green-900 font-bold mb-1">Seuil Alerte stock</label>
                        <input type="number" name="seuilQte" id="seuilVar" value="5" min="0" class="input-forge" required>
                    </div>
                    <!-- Images existantes de la déclinaison -->
                    <div class="col-span-2">
                        <label class="block text-green-900 font-bold mb-1">Images</label>
                        <div id="imagesVariante" class="flex gap-2 flex-wrap overflow-y:auto">
                            <!-- Les images seront injectées ici par JS -->
                        </div>
                        <!-- Input pour ajouter de nouvelles images -->
                        <input type="file" name="images[]" multiple class="input-forge mt-2">
                    </div>

                    <div class="col-span-2 mt-4 pt-4 border-t border-yellow-600/20 flex justify-end gap-3">
                        <button type="button" onclick="closeModal('modalVariante')" class="px-4 py-2 border border-green-800 text-green-800 rounded">Annuler</button>
                        <button type="submit" class="px-6 py-2 bg-[#1A4D2E] text-yellow-400 font-bold rounded border-2 border-yellow-500 shadow-lg">Enregistrer Variante</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        /**
         *Fonction permettant de montrer ou cacher le tableau des variantes 
         d'un produit
         */
        function toggleVariantes(id) {
            const row = document.getElementById(id);
            const icon = document.getElementById('icon-' + id);
            if (row.classList.contains('hidden-row')) {
                row.classList.remove('hidden-row');
                icon.classList.add('rotate-90');
            } else {
                row.classList.add('hidden-row');
                icon.classList.remove('rotate-90');
            }
        }
        /**
         * Permet de cacher une fenetre modale
         */
        function closeModal(id) {
            document.getElementById(id).classList.add('hidden');
            document.getElementById(id).classList.remove('flex');
        }
        /**
         * Permet d'ouvrir la fenetre de création d'un produit (parent)
         */
        function openModalParent() {
            document.getElementById('formParent').reset();
            document.getElementById('idProduit').value = "";
            document.getElementById('titreParent').innerText = "Créer un nouveau produit";

            //On affiche la fenetre modale
            const m = document.getElementById('modalParent');
            m.classList.remove('hidden');
            m.classList.add('flex');
        }

        /**
         * Permet d'ouvrir la fenetre d'édition d'un produit parent
         */
        function editParent(produitParent) {
            //Reset le formulaire
            document.getElementById('formParent').reset();
            //Pré remplissage des champs du formulaire
            document.getElementById('idProduit').value = produitParent.idProduit;
            document.getElementById('nomProduit').value = produitParent.libelle;
            document.getElementById('descriptionProduit').value = produitParent.description;
            document.getElementById('categorie').value = produitParent.categorie_id ?? ""; //Si l'id est null on sélectionne le "Aucune catégorie" qui a "" comme value

            document.getElementById('titreParent').innerText = "Modifier un produit";
            //On affiche la fenetre modale
            const m = document.getElementById('modalParent');
            m.classList.remove('hidden');
            m.classList.add('flex');
        }



        /**
         * Fonction permetant d'afficher le menu de création d'une déclinaison / variante
         * prends en paramètre l'id du produit parent
         */
        function openModalVariante(parentId) {
            document.getElementById('formVariante').reset();
            document.getElementById('idVar').value = "";
            document.getElementById('idParentForVar').value = parentId; //id du produit parent de la variante injecté dans le formulaire
            document.getElementById('titleVariante').innerText = "Ajouter une Variante";

            //On affiche la fenetre modale
            const m = document.getElementById('modalVariante');
            m.classList.remove('hidden');
            m.classList.add('flex');
        }
        /**
         * Fonction permetant d'afficher le menu d'édition d'une déclinaison / variante
         * data : objet json contenant toutes les infos de la déclinaison
         */
        function editVariante(data) {
            console.log(data);
            //Remplace chaque élément texte
            document.getElementById('idParentForVar').value = data.idProduit;
            document.getElementById('idVar').value = data.idDeclinaison;
            document.getElementById('libelleVar').value = data.libelleDeclinaison;
            document.getElementById('prixVar').value = data.prix;
            document.getElementById('stockVar').value = data.qteStock;
            document.getElementById('qualiteVar').value = data.qualite;
            document.getElementById('seuilVar').value = data.seuilQte;
            document.getElementById('descriptionDeclinaison').value = data.descDeclinaison;
            document.getElementById('ficheTechniqueDeclinaison').value = data.ficheTechnique;
            document.getElementById('provenanceDeclinaison').value = data.provenance;
            document.getElementById('prixSoldeDeclinaison').value = data.prixSolde;
            document.getElementById('titleVariante').innerText = "Modifier Variante : " + data.libelleDeclinaison;


            // Container des images
            const container = document.getElementById('imagesVariante');
            container.innerHTML = ''; // vide le container avant de réinjecter

            //On parchours chaque photos du tableau
            if (data.photos && data.photos.length > 0) {
                data.photos.forEach(url => {
                    const wrapper = document.createElement('div'); //On crée une div dans laquelle on placera l'image et la croix
                    wrapper.className = "relative"; // pour positionner le bouton sur l'image

                    // L'image
                    const img = document.createElement('img');
                    img.src = url;
                    img.alt = "Image de la déclinaison";
                    img.className = "w-32 h-32 object-cover border rounded";

                    // Le bouton supprimer
                    const btn = document.createElement('button');
                    btn.type = "button"; // pour éviter de submit le form
                    btn.innerText = "×";
                    btn.className = "absolute top-0 right-0 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm hover:bg-red-700";


                    // Input caché pour l'image
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = "hidden";
                    //L'image est ajoutée dans ce tableau lors de l'envoi du formulaire.
                    //Cela permet d'avoir toutes les images dans un seul tableau quand le serveur récupère les données du formulaire
                    hiddenInput.name = "images_existantes[]"; // le serveur récupère ce tableau
                    hiddenInput.value = url;

                    // Action du bouton
                    btn.onclick = () => {
                        //On supprime l'image du conteneur d'images
                        container.removeChild(wrapper);
                        // on retire aussi le hiddenInput
                        wrapper.removeChild(hiddenInput);
                    };

                    // On met l'image et le bouton dans le wrapper
                    wrapper.appendChild(img);
                    wrapper.appendChild(btn);
                    //On ajoute l'input cachée (pour envoyer l'image dans le formulaire)
                    wrapper.appendChild(hiddenInput);
                    // On ajoute le wrapper au container
                    container.appendChild(wrapper);
                });
            }



            //Afficher la fenetre
            const m = document.getElementById('modalVariante');
            m.classList.remove('hidden');
            m.classList.add('flex');
        }
    </script>
</body>

</html>