<?php
session_start();
// Vérification de la session administrateur
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

require "../connec.inc.php"; 

$msg = "";
$error = false;

// --- 1. LOGIQUE DE MISE À JOUR (UPDATE) ---
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['action_update_status'])) {
    $idCmd = $_POST['idCommande'];
    $nouveauStatut = $_POST['statutCommande'];
    
    // Récupération des dates (NULL si vide pour respecter tes CHECK SQL)
    $dateExp = !empty($_POST['dateExpedition']) ? $_POST['dateExpedition'] : null;
    $dateRec = !empty($_POST['dateReception']) ? $_POST['dateReception'] : null;

    try {
        $sql = "UPDATE Commande 
                SET statutCommande = :statut, 
                    dateExpedition = :dateExp, 
                    dateReception = :dateRec 
                WHERE idCommande = :id";
        
        $stmt = $connection->prepare($sql);
        $stmt->execute([
            ':statut' => $nouveauStatut,
            ':dateExp' => $dateExp,
            ':dateRec' => $dateRec,
            ':id'      => $idCmd
        ]);
        
        $msg = "La commande #$idCmd a été mise à jour avec succès.";
    } catch (PDOException $e) {
        $error = true;
        $msg = "Erreur SQL : " . $e->getMessage();
    }
}

// --- 2. RÉCUPÉRATION DES DONNÉES (Tri : À traiter d'abord, puis chronologique) ---
try {
    /* LOGIQUE DE TRI :
       1. On place les statuts 'livree' et 'annulee' à la fin (0 pour payee/expediee, 1 pour livree/annulee)
       2. À l'intérieur de ces groupes, on trie par date de la plus ancienne à la plus récente
    */
    $sqlSelect = "SELECT c.*, cl.nom, cl.prenom 
                  FROM Commande c 
                  JOIN Client cl ON c.idClient = cl.idClient 
                  ORDER BY 
                    (statutCommande = 'livree' OR statutCommande = 'annulee') ASC, 
                    c.dateCommande ASC"; 
    
    $query = $connection->query($sqlSelect); 
    $commandes = $query->fetchAll(PDO::FETCH_ASSOC);

    // Comptage "À TRAITER"
    $aGerer = 0;
    foreach($commandes as $c) {
        if (in_array(strtolower($c['statutCommande']), ['payee', 'expediee'])) {
            $aGerer++;
        }
    }
} catch (PDOException $e) {
    die("Erreur de lecture : " . $e->getMessage());
}

// Helper pour les couleurs des badges
function getStatusBadge($statut) {
    switch(strtolower($statut)) { 
        case 'payee': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
        case 'expediee': return 'bg-blue-100 text-blue-800 border-blue-200';
        case 'livree': return 'bg-green-100 text-green-800 border-green-200';
        case 'annulee': return 'bg-red-100 text-red-700 border-red-300';
        default: return 'bg-gray-100 text-gray-800';
    }
}

function getStatusIcon($statut) {
    switch(strtolower($statut)) {
        case 'payee': return '💰';
        case 'expediee': return '🚚';
        case 'livree': return '✅';
        case 'annulee': return '❌';
        default: return '❓';
    }
}
?>
<!doctype html>
<html lang="fr" class="h-full">

<link rel="stylesheet" href="../css/styleAdmin.css">
<style>
        .bg-parchemin-admin { background-color: #F5F5DC; }
        .modal-magique { background: #FAF9F0; border: 2px solid #ca8a04; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.6); }
        .input-forge { width: 100%; background-color: #fffbef; border: 1px solid #b45309; padding: 8px; border-radius: 4px; color: #14532d; }
        .custom-scrollbar::-webkit-scrollbar { width: 8px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background-color: #ca8a04; border-radius: 4px; }
    </style>

<?php
include_once '../includes/head.php';

?>

<body class="bg-parchemin-admin h-full flex overflow-hidden font-body">

    <?php include_once '../includes/navAdmin.php'; ?>

    <main class="flex-1 flex flex-col h-full overflow-hidden relative z-10">
        
        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8 shadow-sm">
            <h2 class="text-2xl font-bold text-green-900">Registre des Commandes</h2>
            <div class="flex items-center gap-3">
                <div class="text-sm text-yellow-800 bg-yellow-100 px-3 py-1 rounded-full border border-yellow-200">
                    <span class="font-bold"><?php echo $aGerer; ?></span> À traiter en priorité
                </div>
                <div class="text-sm text-gray-600 bg-gray-100 px-3 py-1 rounded-full border border-gray-200">
                    Total: <?php echo count($commandes); ?>
                </div>
            </div>
        </header>

        <div class="flex-1 overflow-y-auto p-8 custom-scrollbar">
            
            <?php if($msg): ?>
                <div class="mb-4 p-4 rounded border-l-4 <?php echo $error ? 'bg-red-100 border-red-500 text-red-800' : 'bg-green-100 border-green-500 text-green-800'; ?>">
                    <?php echo $msg; ?>
                </div>
            <?php endif; ?>

            <div class="relative mb-6">
                <input type="text" id="searchOrder" onkeyup="filtrerCommandes()" placeholder="Rechercher par N° ou Client..." 
                       class="w-full pl-10 pr-4 py-2 border border-yellow-600/30 rounded-lg bg-[#FAF9F0] focus:outline-none focus:border-yellow-500 shadow-sm">
            </div>

            <div class="bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg overflow-hidden">
                <table class="min-w-full divide-y divide-yellow-600/20" id="orderTable">
                    <thead class="bg-[#1A4D2E]">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-yellow-400 uppercase">N° Cmd</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-yellow-400 uppercase">Client</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-yellow-400 uppercase">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-yellow-400 uppercase">Montant</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-yellow-400 uppercase">Statut</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-yellow-400 uppercase">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-yellow-600/20">
                        <?php foreach($commandes as $cmd): 
                            $isFini = in_array(strtolower($cmd['statutCommande']), ['livree', 'annulee']);
                        ?>
                        <tr class="hover:bg-yellow-50/50 transition <?php echo $isFini ? 'opacity-60 bg-gray-50/30' : ''; ?>">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-mono font-bold order-id">#<?php echo $cmd['idCommande']; ?></td>
                            <td class="px-6 py-4 order-client">
                                <div class="text-sm font-medium text-green-900"><?php echo $cmd['prenom'] . ' ' . $cmd['nom']; ?></div>
                                <div class="text-xs text-gray-500"><?php echo $cmd['typePaiement']; ?></div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <?php echo date('d/m/Y H:i', strtotime($cmd['dateCommande'])); ?>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-green-800">
                                <?php echo number_format($cmd['prixTotal'], 2); ?> €
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs font-bold rounded-full border <?php echo getStatusBadge($cmd['statutCommande']); ?>">
                                    <?php echo getStatusIcon($cmd['statutCommande']) . ' ' . strtoupper($cmd['statutCommande']); ?>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                                <?php if (!$isFini): ?>
                                    <button onclick='manageOrder(<?php echo json_encode($cmd); ?>)' class="text-indigo-600 hover:text-indigo-900 font-bold bg-indigo-50 px-3 py-1 rounded transition-colors">
                                        Gérer
                                    </button>
                                <?php else: ?>
                                    <span class="text-gray-400 italic text-xs">Terminé</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <div id="orderModal" class="fixed inset-0 bg-black/60 hidden z-50 items-center justify-center p-4 backdrop-blur-sm">
        <div class="modal-magique w-full max-w-lg rounded-lg overflow-hidden relative">
            <div class="bg-[#FAF9F0] p-6 border-b border-yellow-600/20 flex justify-between items-center">
                <h3 class="text-xl font-bold text-green-900">Mise à jour Commande <span id="modalOrderId" class="text-yellow-600"></span></h3>
                <button onclick="closeModal()" class="text-gray-500 hover:text-red-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M6 18L18 6M6 6l12 12" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </button>
            </div>
            <div class="p-6 bg-[#F5F5DC]">
                <form method="POST" class="space-y-6">
                    <input type="hidden" name="action_update_status" value="1">
                    <input type="hidden" name="idCommande" id="inputIdCmd">

                    <div class="bg-yellow-50 p-3 rounded border border-yellow-200 text-sm text-yellow-800">
                        <span class="font-bold">Client :</span> <span id="modalClientName"></span><br>
                        <span class="font-bold">Total :</span> <span id="modalTotal"></span>
                    </div>

                    <div>
                        <label class="block text-green-900 font-bold mb-1 text-sm">Nouveau Statut</label>
                        <select name="statutCommande" id="inputStatut" class="input-forge" onchange="toggleDateFields()">
                            <option value="payee">💰 Payée</option>
                            <option value="expediee">🚚 Expédiée</option>
                            <option value="livree">✅ Livrée</option>
                        </select>
                    </div>

                    <div id="dateExpField" class="hidden">
                        <label class="block text-green-900 font-bold mb-1 text-sm">Date d'Expédition</label>
                        <input type="datetime-local" name="dateExpedition" id="inputDateExp" class="input-forge">
                    </div>

                    <div id="dateRecField" class="hidden">
                        <label class="block text-green-900 font-bold mb-1 text-sm">Date de Réception</label>
                        <input type="datetime-local" name="dateReception" id="inputDateRec" class="input-forge">
                    </div>

                    <div class="flex justify-end gap-3 pt-4 border-t border-yellow-600/20">
                        <button type="button" onclick="closeModal()" class="px-4 py-2 border border-green-800 text-green-800 rounded hover:bg-green-100 transition-colors">Annuler</button>
                        <button type="submit" class="px-6 py-2 bg-green-900 text-yellow-400 font-bold rounded border-2 border-yellow-500 hover:bg-green-950 shadow-lg">Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const modal = document.getElementById('orderModal');

        function filtrerCommandes() {
            const filter = document.getElementById('searchOrder').value.toUpperCase();
            const rows = document.querySelectorAll("#orderTable tbody tr");
            rows.forEach(row => {
                const text = row.querySelector(".order-id").innerText + row.querySelector(".order-client").innerText;
                row.style.display = text.toUpperCase().includes(filter) ? "" : "none";
            });
        }

        function toggleDateFields() {
            const stat = document.getElementById('inputStatut').value;
            const divExp = document.getElementById('dateExpField');
            const divRec = document.getElementById('dateRecField');

            divExp.classList.toggle('hidden', !['expediee', 'livree'].includes(stat));
            divRec.classList.toggle('hidden', stat !== 'livree');
            
            const now = new Date().toISOString().slice(0,16);
            if(stat === 'expediee' && !document.getElementById('inputDateExp').value) document.getElementById('inputDateExp').value = now;
            if(stat === 'livree' && !document.getElementById('inputDateRec').value) document.getElementById('inputDateRec').value = now;
        }

        function manageOrder(data) {
            document.getElementById('inputIdCmd').value = data.idCommande;
            document.getElementById('modalOrderId').innerText = "#" + data.idCommande;
            document.getElementById('modalClientName').innerText = data.prenom + " " + data.nom;
            document.getElementById('modalTotal').innerText = data.prixTotal + " €";
            document.getElementById('inputStatut').value = data.statutCommande;
            document.getElementById('inputDateExp').value = data.dateExpedition ? data.dateExpedition.replace(' ', 'T').slice(0,16) : "";
            document.getElementById('inputDateRec').value = data.dateReception ? data.dateReception.replace(' ', 'T').slice(0,16) : "";
            toggleDateFields();
            modal.classList.replace('hidden', 'flex');
        }

        function closeModal() { modal.classList.replace('flex', 'hidden'); }
    </script>
</body>
</html>