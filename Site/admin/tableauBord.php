<?php
session_start();
// Vérification session
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

require "../connec.inc.php";

if (!isset($pdo) && isset($connection)) $pdo = $connection;

// --- DATES & UTILITAIRES ---
$anneeActuelle = date('Y');
$moisActuel = date('m');

$moisFrancais = [
    1 => 'Janvier', 2 => 'Février', 3 => 'Mars', 4 => 'Avril', 5 => 'Mai', 6 => 'Juin',
    7 => 'Juillet', 8 => 'Août', 9 => 'Septembre', 10 => 'Octobre', 11 => 'Novembre', 12 => 'Décembre'
];

$nomMoisActuel = $moisFrancais[(int)$moisActuel];

// Calcul du mois précédent (pour les KPI temps réel)
$timestampPrecedent = strtotime('-1 month');
$moisPrecedent = date('m', $timestampPrecedent);
$anneeMoisPrecedent = date('Y', $timestampPrecedent);
$nomMoisPrecedent = $moisFrancais[(int)$moisPrecedent];


// --- 0. GESTION DES ANNÉES DISPONIBLES ---
$sqlAnnees = "SELECT DISTINCT YEAR(dateCommande) as annee 
              FROM Commande 
              WHERE statutCommande IN ('payee', 'expediee', 'livree') 
              ORDER BY annee DESC";
$stmt = $pdo->query($sqlAnnees);
$anneesDispo = $stmt->fetchAll(PDO::FETCH_COLUMN);

if (empty($anneesDispo)) {
    $anneesDispo = [$anneeActuelle];
}

$selectedYear = isset($_GET['year']) ? (int)$_GET['year'] : $anneeActuelle;

if (!in_array($selectedYear, $anneesDispo) && $selectedYear != $anneeActuelle) {
    $selectedYear = $anneeActuelle;
}


// --- 1. CALCULS KPI (Temps Réel) ---

// A. TRÉSORERIE MENSUELLE (Toujours le mois en cours réel)
$sqlCaCurrent = "SELECT SUM(prixTotal) FROM Commande 
                  WHERE statutCommande IN ('payee', 'expediee', 'livree') 
                  AND MONTH(dateCommande) = :m AND YEAR(dateCommande) = :y";
$stmt = $pdo->prepare($sqlCaCurrent);
$stmt->execute(['m' => $moisActuel, 'y' => $anneeActuelle]);
$caMensuel = $stmt->fetchColumn() ?: 0;

// B. CA du mois PRÉCÉDENT (Pour le %)
$stmt->execute(['m' => $moisPrecedent, 'y' => $anneeMoisPrecedent]);
$caPrev = $stmt->fetchColumn() ?: 0;

// C. Pourcentage
$percentChange = 0;
if ($caPrev > 0) {
    $percentChange = (($caMensuel - $caPrev) / $caPrev) * 100;
} elseif ($caMensuel > 0) {
    $percentChange = 100; 
}
$isPositive = $percentChange >= 0;
$colorClass = $isPositive ? 'text-green-400' : 'text-red-400';
$arrow = $isPositive ? '▲' : '▼';
$sign = $isPositive ? '+' : '';


// --- 2. CALCULS KPI (Synchronisation avec Gestion des Commandes) ---

// NOUVEAU : Commandes à traiter (Payées + Expédiées)
$sqlAGerer = "SELECT COUNT(*) FROM Commande WHERE statutCommande IN ('payee', 'expediee')";
$stmt = $pdo->query($sqlAGerer);
$a_gerer_count = $stmt->fetchColumn();

// TOTAL ANNÉE SÉLECTIONNÉE
$sqlCaAnnuel = "SELECT SUM(prixTotal) FROM Commande 
                WHERE statutCommande IN ('payee', 'expediee', 'livree') 
                AND YEAR(dateCommande) = :y";
$stmt = $pdo->prepare($sqlCaAnnuel);
$stmt->execute(['y' => $selectedYear]);
$caAnnuelSelectionne = $stmt->fetchColumn() ?: 0;

// AUTRES KPI OPÉRATIONNELS
$sqlUrgence = "SELECT COUNT(*) FROM Avis A LEFT JOIN ReponseAvis R ON A.idAvis = R.idAvis WHERE R.idReponse IS NULL";
$stmt = $pdo->query($sqlUrgence);
$urgence_count = $stmt->fetchColumn();

$sqlStock = "SELECT COUNT(*) FROM DeclinaisonProduit WHERE qteStock <= seuilQte";
$stmt = $pdo->query($sqlStock);
$stock_critique = $stmt->fetchColumn();


// --- 3. GRAPHIQUE ---
$ventesParMois = array_fill(1, 12, 0);
$sqlChart = "SELECT MONTH(dateCommande) as mois, SUM(prixTotal) as total 
             FROM Commande 
             WHERE statutCommande IN ('payee', 'expediee', 'livree') 
             AND YEAR(dateCommande) = :annee 
             GROUP BY MONTH(dateCommande)";
$stmt = $pdo->prepare($sqlChart);
$stmt->execute(['annee' => $selectedYear]);

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $ventesParMois[$row['mois']] = $row['total'];
}
$dataChartJS = implode(',', array_values($ventesParMois));


// --- 4. ACTIVITÉS ---
$activites = [];
$sqlLastCmd = "SELECT C.idCommande, C.dateCommande, Cl.nom, Cl.prenom FROM Commande C JOIN Client Cl ON C.idClient = Cl.idClient WHERE C.statutCommande != 'annulee' ORDER BY C.dateCommande DESC LIMIT 3";
foreach ($pdo->query($sqlLastCmd) as $cmd) {
    $activites[] = ['type' => 'commande', 'message' => "Commande #CMD-" . $cmd['idCommande'] . " par " . $cmd['prenom'] . " " . substr($cmd['nom'], 0, 1) . ".", 'date' => $cmd['dateCommande'], 'timestamp' => strtotime($cmd['dateCommande'])];
}
$sqlLastAvis = "SELECT A.dateAvis, P.libelle FROM Avis A JOIN DeclinaisonProduit DP ON A.idDeclinaisonProduit = DP.idDeclinaison JOIN Produit P ON DP.idProduit = P.idProduit ORDER BY A.dateAvis DESC LIMIT 3";
foreach ($pdo->query($sqlLastAvis) as $avis) {
    $activites[] = ['type' => 'avis', 'message' => "Nouvel avis reçu sur : " . substr($avis['libelle'], 0, 25) . "...", 'date' => $avis['dateAvis'], 'timestamp' => strtotime($avis['dateAvis'])];
}
usort($activites, function($a, $b) { return $b['timestamp'] - $a['timestamp']; });
$activites = array_slice($activites, 0, 5);

function tempsEcoule($datetime) {
    $seconds = time() - strtotime($datetime);
    if($seconds <= 60) return "À l'instant";
    else if(round($seconds/60) <= 60) return "Il y a " . round($seconds/60) . " min";
    else if(round($seconds/3600) <= 24) return "Il y a " . round($seconds/3600) . " h";
    else return "Il y a " . round($seconds/86400) . " j";
}
?>

<!doctype html>
<html lang="fr" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Le Roi Merlin</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=MedievalSharp&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
          theme: {
            extend: {
              fontFamily: {
                display: ['MedievalSharp', 'serif'],
                body: ['Poppins', 'sans-serif'],
              }
            }
          }
        }
    </script>

    <link rel="stylesheet" href="../css/styleAdmin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        .select-annee {
            background-color: #fffbef;
            border: 1px solid #ca8a04;
            color: #166534;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            outline: none;
        }
        .select-annee:focus {
            box-shadow: 0 0 0 2px rgba(202, 138, 4, 0.5);
        }
    </style>
</head>

<body class="font-body bg-parchemin-admin h-full flex overflow-hidden">

    <?php include '../includes/navAdmin.php'; ?>

    <main class="flex-1 flex flex-col h-full overflow-hidden relative">
        
        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8 shadow-sm z-10">
            <h2 class="text-2xl font-display font-bold text-green-900">Vue du RoiMerlin</h2>
        </header>

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

        <div class="flex-1 overflow-y-auto p-8">
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6 mb-8">
                
                <div class="card-magique rounded-xl p-6 text-white relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-20">
                        <svg class="w-16 h-16 text-yellow-300" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"/></svg> 
                    </div>
                    <h3 class="text-yellow-200 text-sm font-semibold uppercase tracking-wider mb-1">TRÉSORERIE (<?php echo strtoupper($nomMoisActuel); ?>)</h3>
                    <div class="text-3xl font-display font-bold text-yellow-400"><?php echo number_format($caMensuel, 2, ',', ' '); ?> €</div>
                    
                    <p class="text-green-200 text-sm mt-2 flex flex-col">
                        <?php if($percentChange != 0): ?>
                            <span class="<?php echo $colorClass; ?> font-bold flex items-center">
                                <?php echo $arrow . ' ' . $sign . number_format($percentChange, 1, ',', ' '); ?>%
                            </span>
                            <span class="opacity-80 text-xs mt-0.5">vs <?php echo $nomMoisPrecedent; ?></span>
                        <?php else: ?>
                            <span class="text-gray-300 opacity-80"><?php echo ($caPrev == 0 && $caMensuel == 0) ? 'Aucune donnée' : 'Stable (0%)'; ?></span>
                        <?php endif; ?>
                    </p>
                </div>

                <div class="card-magique rounded-xl p-6 text-white relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-20">
                        <svg class="w-16 h-16 text-green-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.121 15.536c-1.171 1.952-3.07 1.952-4.242 0-1.172-1.953-1.172-5.119 0-7.072 1.171-1.952 3.07-1.952 4.242 0M8 10.5h4m-4 3h4"></path>
                        </svg>
                    </div>
                    <h3 class="text-yellow-200 text-sm font-semibold uppercase tracking-wider mb-1">TOTAL ANNÉE (<?php echo $selectedYear; ?>)</h3>
                    <div class="text-3xl font-display font-bold text-white"><?php echo number_format($caAnnuelSelectionne, 2, ',', ' '); ?> €</div>
                    <p class="text-green-200 text-sm mt-2">Cumul annuel</p>
                </div>

                <div class="card-magique rounded-xl p-6 text-white relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-20">
                         <svg class="w-16 h-16 text-orange-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clip-rule="evenodd"/></svg>
                    </div>
                    <h3 class="text-yellow-200 text-sm font-semibold uppercase tracking-wider mb-1">URGENCE !</h3>
                    <div class="text-3xl font-display font-bold text-white"><?php echo $a_gerer_count; ?></div>
                    <p class="text-green-200 text-sm mt-2">Commandes en cours</p>
                </div>

                <div class="card-magique rounded-xl p-6 text-white relative overflow-hidden group">
                     <div class="absolute top-0 right-0 p-4 opacity-20">
                         <svg class="w-16 h-16 text-red-400" fill="currentColor" viewBox="0 0 20 20"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
                    </div>
                    <h3 class="text-yellow-200 text-sm font-semibold uppercase tracking-wider mb-1">AVIS CLIENTS</h3>
                    <div class="text-3xl font-display font-bold text-red-300"><?php echo $urgence_count; ?></div>
                    <p class="text-green-200 text-sm mt-2">Réponses en attente</p>
                </div>

                <div class="card-magique rounded-xl p-6 text-white relative overflow-hidden group">
                     <div class="absolute top-0 right-0 p-4 opacity-20">
                         <svg class="w-16 h-16 text-purple-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7 2a1 1 0 00-.707 1.707L7 4.414v3.758a1 1 0 01-.293.707l-4 4C.817 14.769 2.156 18 4.828 18h10.343c2.673 0 4.012-3.231 2.122-5.121l-4-4A1 1 0 0113 8.172V4.414l.707-.707A1 1 0 0013 2H7zm2 6.172V4h2v4.172a3 3 0 00.879 2.12l1.027 1.028a4 4 0 00-2.171.102l-.47.156a4 4 0 01-2.53 0l-.563-.187a1.993 1.993 0 00-.114-.035l1.063-1.063A3 3 0 009 8.172z" clip-rule="evenodd"/></svg>
                    </div>
                    <h3 class="text-yellow-200 text-sm font-semibold uppercase tracking-wider mb-1">STOCKS</h3>
                    <div class="text-3xl font-display font-bold text-white"><?php echo $stock_critique; ?></div>
                    <p class="text-green-200 text-sm mt-2">Articles sous le seuil</p>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                
                <div class="lg:col-span-2 bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg p-6">
                    <div class="flex items-center justify-between mb-6">
                        <h3 class="text-xl font-display font-bold text-green-900 flex items-center">
                            <span class="w-2 h-8 bg-yellow-500 mr-3 rounded-full"></span>
                            Ventes du RoiMerlin (<?php echo $selectedYear; ?>)
                        </h3>
                        
                        <form method="GET" action="">
                            <select name="year" class="select-annee" onchange="this.form.submit()">
                                <?php foreach($anneesDispo as $annee): ?>
                                    <option value="<?php echo $annee; ?>" <?php echo ($annee == $selectedYear) ? 'selected' : ''; ?>>
                                        Année <?php echo $annee; ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </form>
                    </div>
                    
                    <div class="relative h-72 w-full">
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>

                <div class="bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg p-6">
                    <h3 class="text-xl font-display font-bold text-green-900 mb-6 flex items-center">
                        <svg class="w-6 h-6 mr-2 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                        Dernières Activités
                    </h3>
                    
                    <div class="space-y-4">
                        <?php if(empty($activites)): ?>
                            <p class="text-sm text-gray-500 italic">Le royaume est bien calme...</p>
                        <?php else: ?>
                            <?php foreach($activites as $act): ?>
                            <div class="flex items-start pb-4 border-b border-gray-200 last:border-0">
                                <div class="flex-shrink-0 mr-3">
                                    <?php if($act['type'] == 'commande'): ?>
                                        <span class="h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                                        </span>
                                    <?php elseif($act['type'] == 'avis'): ?>
                                        <span class="h-8 w-8 rounded-full bg-yellow-100 flex items-center justify-center text-yellow-600">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg>
                                        </span>
                                    <?php endif; ?>
                                </div>
                                <div>
                                    <p class="text-sm font-semibold text-gray-800"><?php echo htmlspecialchars($act['message']); ?></p>
                                    <p class="text-xs text-gray-500 mt-1"><?php echo tempsEcoule($act['date']); ?></p>
                                </div>
                            </div>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                    
                    <a href="crudCommande.php" class="block text-center w-full mt-4 py-2 border border-green-800 text-green-800 rounded hover:bg-green-800 hover:text-white transition-colors text-sm font-semibold">
                        Gérer les commandes
                    </a>
                </div>
            </div>

        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('salesChart').getContext('2d');
            let gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(212, 175, 55, 0.4)');
            gradient.addColorStop(1, 'rgba(212, 175, 55, 0.0)');

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'],
                    datasets: [{
                        label: 'Ventes (EUR)',
                        data: [<?php echo $dataChartJS; ?>],
                        borderColor: '#ca8a04',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointBackgroundColor: '#064e3b',
                        pointBorderColor: '#ca8a04',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: 'rgba(0, 0, 0, 0.05)' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        });
    </script>
</body>
</html>