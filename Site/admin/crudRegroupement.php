<?php

session_start();
// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}


require_once "../connec.inc.php";
require_once "./traitRegroupement.php";

// --- 1. LOGIQUE PHP ---
$msg = "";

// Traitement des requêtes 
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    $action = $_POST['action'];
    
    try {
        switch ($action) {
            case 'delete_regroupement':
                if (!isset($_POST['idRegroupement'])) {
                    echo json_encode(['success' => false, 'message' => 'ID du regroupement manquant']);
                    exit;
                }
                
                $idRegroupement = intval($_POST['idRegroupement']);
                testerRegroupement($idRegroupement);
                
                $connection->beginTransaction();
                try {
                    $stmt = $connection->prepare("DELETE FROM Regrouper WHERE idRegroupement = :idRegroupement");
                    $stmt->execute(['idRegroupement' => $idRegroupement]);
                    
                    $stmt = $connection->prepare("DELETE FROM Regroupement WHERE idRegroupement = :idRegroupement");
                    $stmt->execute(['idRegroupement' => $idRegroupement]);
                    
                    $connection->commit();
                    echo json_encode(['success' => true, 'message' => 'Regroupement supprimé avec succès']);
                } catch (Exception $e) {
                    $connection->rollBack();
                    throw $e;
                }
                break;
                
            default:
                echo json_encode(['success' => false, 'message' => 'Action inconnue']);
                break;
        }
    } catch (PDOException $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        error_log($e->getMessage());
        echo json_encode(['success' => false, 'message' => 'Erreur inattendue lors de l\'opération.']);
    } catch (Exception $e) {
        if ($connection->inTransaction()) {
            $connection->rollBack();
        }
        echo json_encode(['success' => false, 'message' => 'Erreur : ' . $e->getMessage()]);
    }
    exit;
}

// Action sur un regroupement
if (isset($_POST['action_regroupement'])) {
    $resultat = traiterRegroupement($_POST);
    //Erreur
    if ($resultat != 'insert' && $resultat != 'update') {
        $msg = $resultat;
    }
    //Succès
    if ($resultat == 'insert') {
        $msg = "Un nouveau regroupement de tri a été créé !";
    } else if ($resultat == 'update') {
        $msg = "La collection a été mise à jour !";
    }
}

// --- 2. EXTRACTION DES DONNÉES DE LA BASE ---

// Récupérer tous les produits disponibles
$tousLesProduits = [];
try {
    $stmt = $connection->query("SELECT * FROM Produit ORDER BY libelle");
    $tousLesProduits = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    if (empty($msg)) {
        $msg = "Erreur lors de la récupération des produits : " . $e->getMessage();
    }
}

// Récupérer tous les regroupements avec leurs produits associés
$regroupements = [];
try {
    $stmt = $connection->query("SELECT * FROM Regroupement ORDER BY libelle");
    $regroupementsBruts = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    foreach ($regroupementsBruts as $reg) {
        $idRegroupement = $reg['idRegroupement'];
        
        $stmtProduits = $connection->prepare("
            SELECT P.idProduit, P.libelle, P.description
            FROM Regrouper R
            INNER JOIN Produit P ON R.idProduit = P.idProduit
            WHERE R.idRegroupement = :idRegroupement
            ORDER BY P.libelle
        ");
        $stmtProduits->execute(['idRegroupement' => $idRegroupement]);
        $produitsAssocies = $stmtProduits->fetchAll(PDO::FETCH_ASSOC);
        
        $idsProduits = array_map(function ($p) {
            return (int)$p['idProduit'];
        }, $produitsAssocies);
        
        $colors = [
            'bg-blue-100 text-blue-800',
            'bg-red-100 text-red-800',
            'bg-green-100 text-green-800',
            'bg-purple-100 text-purple-800',
            'bg-yellow-100 text-yellow-800',
            'bg-indigo-100 text-indigo-800',
            'bg-pink-100 text-pink-800',
            'bg-orange-100 text-orange-800'
        ];
        $colorIndex = ($idRegroupement - 1) % count($colors);
        
        $regroupements[] = [
            'id' => $idRegroupement,
            'libelle' => $reg['libelle'],
            'color' => $colors[$colorIndex],
            'idsProduits' => $idsProduits,
            'produits' => $produitsAssocies,
            'nbProduits' => count($produitsAssocies)
        ];
    }
} catch (PDOException $e) {
    if (empty($msg)) {
        $msg = "Erreur lors de la récupération des regroupements : " . $e->getMessage();
    }
}

/**
 * Permet de tester l'existence d'un produit
 */
function testerProduit($idProduit)
{
    global $connection;
    $statement = $connection->prepare("SELECT COUNT(*) FROM Produit WHERE idProduit = :id");
    $statement->execute([':id' => $idProduit]);
    if ($statement->fetchColumn() == 0) {
        throw new Exception("Produit introuvable !");
    }
}

?>
<!doctype html>
<html lang="fr" class="h-full">
<head>
    <?php 
     if(file_exists('../includes/head.php')) { include_once '../includes/head.php'; } 
    else { echo '<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><script src="https://cdn.tailwindcss.com"></script>'; }
    ?>
    <style>
        .bg-parchemin-admin { background-color: #F5F5DC; }
        .modal-magique {
            background: #FAF9F0;
            border: 2px solid #ca8a04;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.6);
        }
        .input-forge {
            width: 100%;
            background-color: #fffbef;
            border: 1px solid #b45309;
            padding: 8px;
            border-radius: 4px;
            color: #14532d;
        }
        .input-forge:focus { outline: none; box-shadow: 0 0 0 2px #ca8a04; }
        
        .checkbox-list {
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid #b45309;
            background-color: #fffbef;
            border-radius: 4px;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #e5e7eb;
            transition: background-color 0.2s;
        }
        .checkbox-item:last-child { border-bottom: none; }
        .checkbox-item:hover { background-color: #fef08a; }

        .custom-scrollbar::-webkit-scrollbar { width: 8px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: #fffbef; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background-color: #ca8a04; border-radius: 4px; }
    </style>
</head>

<body class="font-body bg-parchemin-admin h-full flex overflow-hidden">

     <?php
    include_once __DIR__ . '/../includes/navAdmin.php';;

    ?>

    <main class="flex-1 flex flex-col h-full overflow-hidden relative z-10">
        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8 shadow-sm">
            <h2 class="text-2xl font-display font-bold text-green-900">Collections & Tris (Tags)</h2>
            <button onclick="openModal()" class="bg-[#1A4D2E] text-yellow-400 px-4 py-2 rounded border border-yellow-500 hover:bg-green-800 transition shadow-md flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                Créer une Collection
            </button>
        </header>

        <div class="flex-1 overflow-y-auto p-8">
            <?php if($msg): ?>
                <div class="mb-4 p-4 rounded bg-green-100 border-l-4 border-green-500 text-green-800">
                    <?php echo $msg; ?>
                </div>
            <?php endif; ?>

            <div class="mb-6 bg-yellow-50 border border-yellow-200 p-4 rounded-lg text-sm text-yellow-800 flex items-start">
                <svg class="w-5 h-5 mr-2 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                <p>Ces regroupements apparaissent dans les filtres du catalogue (Nouveautés, Soldes, etc.). Un même artefact peut appartenir à plusieurs collections.</p>
            </div>

            <div class="bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg overflow-hidden">
                <table class="min-w-full divide-y divide-yellow-600/20">
                    <thead class="bg-[#1A4D2E]">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-yellow-400 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-yellow-400 uppercase tracking-wider">Nom du Regroupement</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-yellow-400 uppercase tracking-wider">Produits associés</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-yellow-400 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-yellow-600/20">
                        <?php foreach($regroupements as $r): ?>
                        <tr class="hover:bg-yellow-50/50 transition" data-regroupement-id="<?php echo $r['id']; ?>">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">#<?php echo $r['id']; ?></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 text-sm font-bold rounded-full <?php echo isset($r['color']) ? $r['color'] : 'bg-gray-100 text-gray-800'; ?>">
                                    <?php echo $r['libelle']; ?>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 produit-count" data-regroupement-id="<?php echo $r['id']; ?>">
                                <?php echo $r['nbProduits']; ?> produit(s) lié(s)
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <button class="btn-edit-regroupement text-indigo-600 hover:text-indigo-900 mr-4 font-bold" 
                                        data-regroupement-id="<?php echo $r['id']; ?>"
                                        data-regroupement='<?php echo htmlspecialchars(json_encode($r), ENT_QUOTES, 'UTF-8'); ?>'>
                                    Gérer les produits
                                </button>
                                <button class="btn-delete-regroupement text-red-600 hover:text-red-900 font-bold"
                                        data-id="<?php echo $r['id']; ?>"
                                        data-libelle="<?php echo htmlspecialchars($r['libelle'], ENT_QUOTES); ?>">
                                    Supprimer
                                </button>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <div id="groupModal" class="fixed inset-0 bg-black/60 hidden z-50 items-center justify-center p-4 backdrop-blur-sm">
        <div class="modal-magique w-full max-w-lg rounded-lg overflow-hidden relative animate-fade-in-up">
            
            <div class="bg-[#FAF9F0] p-6 border-b border-yellow-600/20 flex justify-between items-center">
                <h3 id="modalTitle" class="text-xl font-display font-bold text-green-900">Définir une Collection</h3>
                <button onclick="closeModal()" class="text-gray-500 hover:text-red-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <div class="p-6 bg-[#F5F5DC]">
                <form id="groupForm" method="POST" action="" class="space-y-6" onsubmit="return handleFormSubmit(event)">
                    <input type="hidden" name="action_regroupement" value="1">
                    <input type="hidden" name="idRegroupement" id="inputId">

                    <div>
                        <label class="block text-green-900 font-bold mb-1">Nom du Tag / Collection</label>
                        <input type="text" name="libelle" id="inputLibelle" required class="input-forge" placeholder="Ex: Soldes d'Hiver">
                    </div>

                    <div>
                        <label class="block text-green-900 font-bold mb-2">Associer des produits</label>
                        <p class="text-xs text-gray-600 mb-2" id="editModeHint" style="display: none;">
                            <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            Modifiez le nom et sélectionnez les produits, puis cliquez sur "Enregistrer" pour sauvegarder toutes les modifications.
                        </p>
                        
                        <div class="relative mb-2">
                            <input type="text" id="searchProduct" onkeyup="filtrerProduits()" placeholder="Rechercher un artefact..." 
                                   class="input-forge pl-8 text-sm placeholder-gray-500">
                            <div class="absolute inset-y-0 left-0 pl-2 flex items-center pointer-events-none">
                                <svg class="h-4 w-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                            </div>
                        </div>

                        <div class="checkbox-list custom-scrollbar" id="listContainer">
                            <?php foreach($tousLesProduits as $prod): ?>
                                <label class="checkbox-item cursor-pointer">
                                    <input type="checkbox" name="produits[]" value="<?php echo $prod['idProduit']; ?>" class="h-4 w-4 text-green-800 border-gray-300 rounded focus:ring-green-900 checkbox-prod mr-3">
                                    <span class="text-sm font-medium text-green-900 product-label">
                                        <?php echo $prod['libelle']; ?>
                                    </span>
                                </label>
                            <?php endforeach; ?>
                        </div>
                    </div>

                    <div class="flex justify-end gap-3 mt-6 pt-4 border-t border-yellow-600/20">
                        <button type="button" onclick="closeModal()" class="px-4 py-2 border border-green-800 text-green-800 rounded hover:bg-green-100">Annuler</button>
                        <button type="button" onclick="initialiserRegroupement()" class="px-4 py-2 border border-yellow-600 text-yellow-700 rounded hover:bg-yellow-50 font-bold" id="initButton" style="display: none;">
                            Initialiser le regroupement
                        </button>
                        <button type="submit" class="px-6 py-2 bg-[#1A4D2E] text-yellow-400 font-bold rounded border-2 border-yellow-500 hover:bg-green-900 shadow-lg" id="submitButton">
                            Enregistrer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const modal = document.getElementById('groupModal');
        const form = document.getElementById('groupForm');
        const title = document.getElementById('modalTitle');
        let checkboxes = document.querySelectorAll('.checkbox-prod');
        const searchInput = document.getElementById('searchProduct');
        let currentRegroupementId = null;
        let currentRegroupementData = null; // Stocker les données du regroupement actuel

        function filtrerProduits() {
            const filter = searchInput.value.toUpperCase();
            const list = document.getElementById("listContainer");
            const labels = list.getElementsByTagName("label");

            for (let i = 0; i < labels.length; i++) {
                const span = labels[i].getElementsByClassName("product-label")[0];
                const txtValue = span.textContent || span.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    labels[i].style.display = ""; 
                } else {
                    labels[i].style.display = "none";
                }
            }
        }

        function attachCheckboxListeners() {
            checkboxes = document.querySelectorAll('.checkbox-prod');
            // Plus besoin de listeners automatiques, les checkboxes sont gérées par le formulaire
        }

        function openModal() {
            form.reset();
            document.getElementById('inputId').value = "";
            currentRegroupementId = null;
            currentRegroupementData = null;
            title.innerText = "Créer une nouvelle Collection";
            document.getElementById('editModeHint').style.display = 'none';
            document.getElementById('initButton').style.display = 'none';
            searchInput.value = "";
            filtrerProduits(); 
            checkboxes.forEach(cb => cb.checked = false);
            document.getElementById('submitButton').textContent = 'Enregistrer';
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }

        function editRegroupement(data) {
            // Si data est une string (depuis data-attribute), la parser
            if (typeof data === 'string') {
                data = JSON.parse(data);
            }
            
            // Créer une copie profonde des données pour pouvoir les modifier
            currentRegroupementData = JSON.parse(JSON.stringify(data));
            
            document.getElementById('inputId').value = data.id;
            document.getElementById('inputLibelle').value = data.libelle;
            currentRegroupementId = data.id;
            document.getElementById('editModeHint').style.display = 'block';
            searchInput.value = "";
            filtrerProduits();

            // Utiliser les données stockées (qui seront mises à jour après chaque modification AJAX)
            // S'assurer que tous les IDs sont des entiers
            const existingIds = (currentRegroupementData.idsProduits || []).map(id => parseInt(id));
            checkboxes.forEach(cb => {
                const cbValue = parseInt(cb.value);
                cb.checked = existingIds.includes(cbValue);
            });

            attachCheckboxListeners();

            title.innerText = "Modifier la collection : " + data.libelle;
            document.getElementById('submitButton').textContent = 'Enregistrer';
            document.getElementById('initButton').style.display = 'inline-block';
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }
        
        function initialiserRegroupement() {
            if (!currentRegroupementId) {
                return;
            }
            
            if (!confirm('Êtes-vous sûr de vouloir initialiser ce regroupement ?\n\nTous les produits associés seront retirés et le nom sera réinitialisé.')) {
                return;
            }
            
            // Décocher toutes les checkboxes
            checkboxes.forEach(cb => cb.checked = false);
            
            // Réinitialiser le nom
            document.getElementById('inputLibelle').value = '';
        }
        
        function handleFormSubmit(event) {
            // Le formulaire va soumettre normalement avec tous les produits cochés
            return true;
        }

        function closeModal() {
            currentRegroupementId = null;
            currentRegroupementData = null;
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        function deleteRegroupement(id, libelle) {
            if (!confirm(`Êtes-vous sûr de vouloir supprimer le regroupement "${libelle}" ?\n\nCette action est irréversible.`)) {
                return;
            }

            const formData = new FormData();
            formData.append('action', 'delete_regroupement');
            formData.append('idRegroupement', id);

            fetch('crudRegroupement.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const row = document.querySelector(`tr[data-regroupement-id="${id}"]`);
                    if (row) {
                        row.remove();
                    }
                    alert('Regroupement supprimé avec succès');
                    if (currentRegroupementId === id) {
                        closeModal();
                    }
                } else {
                    alert('Erreur : ' + data.message);
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors de la suppression');
            });
        }

        // Utiliser la délégation d'événements pour plus de fiabilité
        document.addEventListener('click', function(e) {
            // Gérer les clics sur les boutons "Gérer les produits"
            if (e.target.classList.contains('btn-edit-regroupement') || e.target.closest('.btn-edit-regroupement')) {
                const btn = e.target.classList.contains('btn-edit-regroupement') ? e.target : e.target.closest('.btn-edit-regroupement');
                const data = btn.getAttribute('data-regroupement');
                if (data) {
                    e.preventDefault();
                    editRegroupement(data);
                }
            }
            
            // Gérer les clics sur les boutons "Supprimer"
            if (e.target.classList.contains('btn-delete-regroupement') || e.target.closest('.btn-delete-regroupement')) {
                const btn = e.target.classList.contains('btn-delete-regroupement') ? e.target : e.target.closest('.btn-delete-regroupement');
                const id = btn.getAttribute('data-id');
                const libelle = btn.getAttribute('data-libelle');
                if (id && libelle) {
                    e.preventDefault();
                    deleteRegroupement(parseInt(id), libelle);
                }
            }
        });

        // Attacher les listeners aux checkboxes au chargement
        document.addEventListener('DOMContentLoaded', function() {
            attachCheckboxListeners();
        });

        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    </script>
</body>
</html>
