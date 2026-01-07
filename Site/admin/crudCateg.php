<?php
ob_start();
session_start();

// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

require_once "../connec.inc.php";
if (!isset($pdo) && isset($connection)) $pdo = $connection;


// --- 1. ACTIONS (Simple et direct) ---

// Suppression
if (isset($_POST['delete_id'])) {
    try {
        $stmt = $pdo->prepare("DELETE FROM Categorie WHERE idCategorie = ?");
        $stmt->execute([$_POST['delete_id']]);
        header("Location: crudCateg.php?msgSucces=Catégorie supprimée avec succès");
        exit();
    } catch (PDOException $e) {
        header("Location: crudCateg.php?msgErreur=Erreur lors de la suppression");
        exit();
    }
}

// Ajout ou Modif
if (isset($_POST['action_categorie'])) {
    $id = $_POST['idCategorie'];
    $libelle = $_POST['libelle'];
    $parent = $_POST['idCategorieParent'] ?: null;
    try {
        if (!empty($id)) {
            $sql = "UPDATE Categorie SET libelle=?, idCategorieParent=? WHERE idCategorie=?";
            $pdo->prepare($sql)->execute([$libelle, $parent, $id]);
            $msg = "Catégorie modifiée avec succès";
        } else {
            $sql = "INSERT INTO Categorie (libelle, idCategorieParent) VALUES (?, ?)";
            $pdo->prepare($sql)->execute([$libelle, $parent]);
            $msg = "Catégorie ajoutée avec succès";
        }
        header("Location: crudCateg.php?msgSucces=" . urlencode($msg));
        exit();
    } catch (PDOException $e) {
        header("Location: crudCateg.php?msgErreur=Erreur lors de l'enregistrement");
        exit();
    }
}

// --- 2. RÉCUPÉRATION (TOUTES les catégories, sans tri hiérarchique SQL) ---

try {
    $categories = $pdo->query("SELECT * FROM Categorie")->fetchAll(PDO::FETCH_ASSOC);
    $listeTousParents = $pdo->query("SELECT * FROM Categorie ORDER BY libelle")->fetchAll();
} catch (PDOException $e) {
    // Redirection avec message d'erreur
    header("Location: crudCateg.php?msgErreur=" . urlencode("Erreur lors de la récupération des catégories"));
    exit();
}

// --- 3. CONSTRUCTION DE L'ARBRE (clé = idCategorieParent) ---

$arbre = [];
foreach ($categories as $cat) {
    $parentId = $cat['idCategorieParent'] ?? 0;
    $arbre[$parentId][] = $cat;
}

$libelles = [];

foreach ($categories as $c) {
    $libelles[$c['idCategorie']] = $c['libelle'];
}

// --- 4. FONCTION D'AFFICHAGE RÉCURSIF ---

function afficherCategories($parentId, $arbre, $libelles, $niveau = 0)
{
    if (!isset($arbre[$parentId])) return;

    foreach ($arbre[$parentId] as $c) {
        echo '<tr class="hover:bg-yellow-50/50">';
        echo '<td class="p-4 text-gray-400 font-mono text-sm">#' . $c['idCategorie'] . '</td>';

        echo '<td class="p-4">';
        if ($niveau > 0) {
            echo '<div class="ml-' . ($niveau * 4) . ' flex items-center gap-2">';
            echo '<span class="text-gray-500">↳</span>';
            echo '<span class="text-[#1A4D2E] font-semibold">' . htmlspecialchars($c['libelle']) . '</span>';
            echo '</div>';
        } else {
            echo '<span class="text-[#1A4D2E] font-bold uppercase">' . htmlspecialchars($c['libelle']) . '</span>';
        }
        echo '</td>';

        echo '<td class="p-4 text-[10px] font-bold">';
        if ($parentId == 0) {
            echo '<span class="bg-gray-300 text-gray-700 px-3 py-1 rounded border border-gray-400/30 uppercase">Racine</span>';
        } else {
            $nomParent = $libelles[$parentId] ?? 'Inconnu';
            echo '<span class="bg-orange-200 text-orange-900 px-3 py-1 rounded border border-orange-400/30 uppercase">'
                . htmlspecialchars($nomParent) .
                '</span>';
        }

        echo '</td>';

        echo '<td class="p-4 text-right">';
        echo '<button 
            onclick=\'editCat(' . htmlspecialchars(json_encode($c), ENT_QUOTES, 'UTF-8') . ')\' 
            class="text-indigo-700 font-bold text-sm underline decoration-indigo-200">
            Modifier
        </button>';
        echo '</td>';
        echo '</tr>';

        // Appel récursif pour les enfants
        afficherCategories($c['idCategorie'], $arbre, $libelles, $niveau + 1);
    }
}
?>

<!doctype html>
<html lang="fr">

<head>
    <?php if (file_exists('../includes/head.php')) include_once '../includes/head.php'; ?>
    <style>
        .font-medieval {
            font-family: 'MedievalSharp', cursive;
        }
    </style>
</head>

<body class="bg-[#F5F5DC] flex font-body">

    <?php include_once '../includes/navAdmin.php'; ?>

    <main class="flex-1 p-8">

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

        <div class="flex justify-between items-center mb-8">
            <h2 class="text-3xl font-bold text-[#1A4D2E] font-medieval">Archives des Catégories</h2>
            <button onclick="openModal()" class="bg-[#1A4D2E] text-yellow-400 px-6 py-2 rounded border border-yellow-500 font-bold uppercase text-xs tracking-widest">
                + Nouvelle Catégorie
            </button>
        </div>

        <div class="bg-white/80 border border-yellow-600/20 rounded-xl overflow-hidden shadow-sm">
            <table class="w-full text-left">
                <thead class="bg-[#1A4D2E] text-yellow-400 text-[10px] uppercase tracking-widest">
                    <tr>
                        <th class="p-4">ID</th>
                        <th class="p-4">Libellé</th>
                        <th class="p-4">Catégorie Parente</th>
                        <th class="p-4 text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <?php afficherCategories(0, $arbre, $libelles); ?>
                </tbody>
            </table>
        </div>
    </main>


    <div id="catModal" class="fixed inset-0 bg-black/60 hidden items-center justify-center z-50">
        <div class="bg-[#F5F5DC] border-2 border-[#ca8a04] w-full max-w-md rounded-lg shadow-2xl">

            <div class="p-4 border-b border-yellow-600/20 flex justify-between bg-[#FAF9F0]">
                <h3 id="modalTitle" class="font-medieval text-xl text-green-900">Catégorie</h3>
                <button onclick="closeModal()" class="text-gray-400">✕</button>
            </div>

            <form method="POST" class="p-6 space-y-4">
                <input type="hidden" name="action_categorie" value="1">
                <input type="hidden" name="idCategorie" id="inputId">

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest mb-1">Nom</label>
                    <input type="text" name="libelle" id="inputLibelle" required class="w-full p-2 border border-yellow-600/30 rounded">
                </div>

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest mb-1">Parent</label>
                    <select name="idCategorieParent" id="inputParent" class="w-full p-2 border border-yellow-600/30 rounded font-bold">
                        <option value="">-- Racine --</option>
                        <?php foreach ($listeTousParents as $p): ?>
                            <option value="<?= $p['idCategorie'] ?>"><?= $p['libelle'] ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div class="flex justify-between items-center pt-4 border-t border-yellow-600/10">
                    <button type="button" id="btnDelete" onclick="confirmDelete()" class="text-red-600 text-[10px] font-bold uppercase underline">Supprimer</button>
                    <div class="flex gap-4">
                        <button type="button" onclick="closeModal()" class="text-gray-500 font-bold text-[10px] uppercase">Annuler</button>
                        <button type="submit" class="bg-[#1A4D2E] text-yellow-400 px-4 py-2 rounded text-[10px] font-bold uppercase">Enregistrer</button>
                    </div>
                </div>
            </form>

            <form id="deleteForm" method="POST" class="hidden"><input type="hidden" name="delete_id" id="deleteInput"></form>
        </div>
    </div>

    <script>
        const modal = document.getElementById('catModal');

        function openModal() {
            document.getElementById('inputId').value = "";
            document.getElementById('inputLibelle').value = "";
            document.getElementById('inputParent').value = "";
            document.getElementById('btnDelete').style.display = 'none';
            modal.classList.replace('hidden', 'flex');
        }

        function editCat(data) {
            document.getElementById('inputId').value = data.idCategorie;
            document.getElementById('inputLibelle').value = data.libelle;
            document.getElementById('inputParent').value = data.idCategorieParent || "";
            document.getElementById('btnDelete').style.display = 'block';
            modal.classList.replace('hidden', 'flex');
        }

        function closeModal() {
            modal.classList.replace('flex', 'hidden');
        }

        function confirmDelete() {
            if (confirm("Supprimer cette catégorie ?")) {
                document.getElementById('deleteInput').value = document.getElementById('inputId').value;
                document.getElementById('deleteForm').submit();
            }
        }
    </script>
</body>

</html>