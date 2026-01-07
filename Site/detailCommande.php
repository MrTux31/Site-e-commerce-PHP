<?php 
session_start();

require_once './includes/utils.php';
// 1. Vérification de sécurité
if (!isset($_SESSION['idClient'])) {
    header('Location: connexion.php');
    exit();
}

$idClient = $_SESSION['idClient'];

// 2. Récupération de l'ID depuis l'URL
if (!isset($_GET['id']) || empty($_GET['id'])) {
    header('Location: mesCommandes.php');
    exit();
}
$commandeId = $_GET['id'];

$commande = null;
$lignes = [];

// 3. Logique de récupération et TRAITEMENT
require_once 'connec.inc.php'; 

if (isset($connection)) {
    try {
        
        // --- LOGIQUE D'ANNULATION (Placée avant l'affichage) ---
        if (isset($_POST['btnAnnulerCommande'])) {
            // Vérification de sécurité : on vérifie le statut actuel en base
            $sqlVerif = "SELECT statutCommande FROM Commande WHERE idCommande = :idCmd AND idClient = :idClient";
            $stmtVerif = $connection->prepare($sqlVerif);
            $stmtVerif->execute([':idCmd' => $commandeId, ':idClient' => $idClient]);
            $etatActuel = $stmtVerif->fetchColumn();

            // Si la commande est bien annulable (Payee ou Expediee)
            if ($etatActuel && in_array(strtolower($etatActuel), ['payee', 'expediee'])) {
                $sqlUpdate = "UPDATE Commande SET statutCommande = 'Annulee' WHERE idCommande = :idCmd";
                $stmtUpdate = $connection->prepare($sqlUpdate);
                $stmtUpdate->execute([':idCmd' => $commandeId]);
                
                // REDIRECTION VERS L'HISTORIQUE
                header("Location: mesCommandes.php");
                exit();
            }
        }
        // -------------------------------------------------------

        // A. Récupérer les infos générales de la commande
        $sqlCmd = "SELECT * FROM Commande WHERE idCommande = :idCmd AND idClient = :idClient";
        $stmt = $connection->prepare($sqlCmd);
        $stmt->execute([':idCmd' => $commandeId, ':idClient' => $idClient]);
        $commande = $stmt->fetch(PDO::FETCH_ASSOC);

        // Si la commande n'existe pas -> Redirection
        if (!$commande) {
            header('Location: mesCommandes.php');
            exit();
        }

        // B. Récupérer les lignes de la commande
        $sqlLignes = "SELECT L.*, D.libelleDeclinaison 
                      FROM LigneCommande L
                      JOIN DeclinaisonProduit D ON L.idDeclinaison = D.idDeclinaison
                      WHERE L.idCommande = :idCmd";
        $stmtLignes = $connection->prepare($sqlLignes);
        $stmtLignes->execute([':idCmd' => $commandeId]);
        $lignes = $stmtLignes->fetchAll(PDO::FETCH_ASSOC);

    } catch (PDOException $e) {
        die("Erreur technique : " . $e->getMessage());
    }
}
?>

<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<body class="font-body bg-parchemin h-full">

<?php 
include_once 'includes/header.php'; 

$statutRaw = $commande['statutCommande']; // Statut brut pour la logique
$statut = htmlspecialchars($statutRaw);   // Statut sécurisé pour l'affichage

// Couleur du badge statut
$badgeClass = 'bg-gray-100 text-gray-800';
switch(strtolower($statut)) {
    case 'livree': $badgeClass = 'bg-green-100 text-green-800'; break;
    case 'expediee': $badgeClass = 'bg-blue-100 text-blue-800'; break;
    case 'payee': $badgeClass = 'bg-yellow-100 text-yellow-800'; break;
    case 'annulee': $badgeClass = 'bg-red-100 text-red-800'; break;
}

// Calcul du sous-total des lignes
$sousTotal = 0;
foreach($lignes as $l) {
    $prixLigne = $l['prixTotal'] ?? 0;
    $sousTotal += $prixLigne;
}

// Frais de port et total
$fraisPort = 0;
$totalCommande = $commande['prixTotal'];
?>

<div id="section-detail-commande" class="section-content w-full py-16 px-4 bg-white min-h-[60vh]">
    <div class="max-w-4xl mx-auto">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
            <h2 class="font-display text-3xl md:text-4xl text-green-800">
                Détails de la Commande #<?php echo htmlspecialchars($commande['numTransaction']); ?>
            </h2>
            <span class="text-sm text-gray-500">ID interne : <?php echo $commandeId; ?></span>
        </div>

        <div class="flex justify-between items-center mb-4">
            <button onclick="window.location.href='mesCommandes.php';" class="text-green-700 hover:text-yellow-600 font-semibold flex items-center gap-2 transition-colors">
                 <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                 Retour à l'historique
            </button>
            
            <?php 
            // Affiche le bouton uniquement si Payee ou Expediee
            if (in_array(strtolower($statutRaw), ['payee', 'expediee'])): 
            ?>
                <form method="POST" onsubmit="return confirm('Êtes-vous sûr de vouloir annuler cette commande ? Cette action est irréversible.');">
                    <button type="submit" name="btnAnnulerCommande" class="bg-red-50 text-red-600 border border-red-200 px-4 py-2 rounded-lg text-sm font-semibold hover:bg-red-100 hover:text-red-800 transition flex items-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                        Annuler la commande
                    </button>
                </form>
            <?php endif; ?>
        </div>
        <div class="p-8 border-2 border-green-700 rounded-xl shadow-2xl bg-white space-y-8">

            <div class="border-b pb-4 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div>
                    <p class="text-lg font-semibold text-gray-700">
                        Date de la commande : 
                        <span class="text-green-800">
                            <?php echo date('d/m/Y à H:i', strtotime($commande['dateCommande'])); ?>
                        </span>
                    </p>
                    <?php if(!empty($commande['dateExpedition'])): ?>
                        <p class="text-sm text-gray-500">Expédiée le : <?php echo date('d/m/Y', strtotime($commande['dateExpedition'])); ?></p>
                    <?php endif; ?>
                </div>
                
                <div class="text-right">
                    <p class="text-lg font-semibold text-gray-700 mb-1">Statut actuel :</p>
                    <span class="px-3 py-1 inline-flex text-base leading-5 font-bold rounded-full <?php echo $badgeClass; ?>">
                        <?php echo ucfirst($statut); ?>
                    </span>
                </div>
            </div>

            <div>
                <h3 class="font-display text-2xl text-yellow-700 mb-4">Artefacts Achetés</h3>
                <div class="space-y-4">
                    
                    <?php foreach ($lignes as $ligne): ?>
                    <a href="consultProduit.php?id=<?php echo$ligne['idDeclinaison'] ?>" class="block mb-4">
                        <div class="flex justify-between items-center p-3 border rounded-lg bg-gray-50 hover:bg-gray-100 transition">
                        
                        <div class="flex items-center gap-4">
                            <div class="w-16 h-16 flex-shrink-0 bg-white border rounded overflow-hidden flex items-center justify-center">
                                <?php 
                                    $mesPhotos = chargerPhotosProduit($ligne['idDeclinaison'], $ligne['libelleDeclinaison']); 
                                    $imgSrc = '';
                                    
                                    if (empty($mesPhotos)) {
                                        $imgSrc = 'https://placehold.co/400x400/228B22/FFFFFF?text=' . urlencode($ligne['libelleDeclinaison']);
                                    } else {
                                        $imgSrc = $mesPhotos[0];
                                    }
                                ?>
                                <img src="<?php echo htmlspecialchars($imgSrc); ?>" 
                                     alt="<?php echo htmlspecialchars($ligne['libelleDeclinaison']); ?>" 
                                     class="w-full h-full object-cover">
                            </div>

                            <div>
                                <span class="font-medium text-gray-800 block text-lg">
                                    <?php echo htmlspecialchars($ligne['libelleDeclinaison']); ?>
                                </span>
                                <span class="text-xs text-gray-500">Réf: <?php echo $ligne['idDeclinaison']; ?></span>
                            </div>
                        </div>

                        <div class="text-right">
                            <span class="block text-sm text-gray-600">Qté: <?php echo $ligne['quantite']; ?></span>
                            <span class="font-semibold text-green-700 text-lg">
                                <?php echo number_format($ligne['prixTotal'], 2, ',', ' '); ?> €
                            </span>
                        </div>
                    </div>
                    </a>
                    <?php endforeach; ?>

                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 border-t pt-6">
                
                <div>
                    <h3 class="font-display text-2xl text-yellow-700 mb-4">Récapitulatif Final</h3>
                    <div class="space-y-2">
                        <div class="flex justify-between text-sm text-gray-700">
                            <span>Sous-total (Articles)</span> 
                            <span><?php echo number_format($sousTotal, 2, ',', ' '); ?> €</span>
                        </div>
                        
                        <?php if ($fraisPort > 0): ?>
                        <div class="flex justify-between text-sm text-gray-700">
                            <span>Livraison</span> 
                            <span><?php echo number_format($fraisPort, 2, ',', ' '); ?> €</span>
                        </div>
                        <?php else: ?>
                        <div class="flex justify-between text-sm text-gray-700">
                            <span>Livraison</span> 
                            <span class="text-green-600 font-bold">Offerte</span>
                        </div>
                        <?php endif; ?>

                         <?php if ($commande['ptsFideliteUsed'] > 0): ?>
                        <div class="flex justify-between text-sm text-gray-700">
                            <span>Points de fidélité utilisés</span> 
                            <span><?php echo number_format($commande['ptsFideliteUsed'], 2, ',', ' '); ?> (Réduction de <?php  echo $commande['ptsFideliteUsed']*0.5 ?>€)</span>
                        </div>
                         <?php endif; ?>


                        <div class="flex justify-between text-sm text-gray-700">
                            <span>Moyen de paiement</span>
                            <span><?php echo htmlspecialchars($commande['typePaiement']); ?></span>
                        </div>

                        <div class="flex justify-between text-xl font-bold text-green-800 border-t pt-4 mt-2">
                            <span>Total Payé</span> 
                            <span class="text-2xl"><?php echo number_format($totalCommande, 2, ',', ' '); ?> €</span>
                        </div>
                    </div>
                </div>

                <div>
                    <h3 class="font-display text-2xl text-yellow-700 mb-4">Adresse de Livraison</h3>
                    <div class="p-4 border rounded-lg bg-gray-50 text-gray-700 space-y-1">
                        <p class="font-semibold mb-2">Expédié à :</p>
                        <p class="whitespace-pre-line leading-relaxed">
                            <?php echo nl2br(htmlspecialchars($commande['adresseLivraison'])); ?>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<?php include_once 'includes/footer.php'; ?>
</body>
</html>

