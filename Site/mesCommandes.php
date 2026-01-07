<?php 
session_start();
ob_start(); 
?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<body class="font-body bg-parchemin h-full">

<?php 
include_once 'includes/header.php'; 

// --- 1. SÉCURITÉ ET RÉCUPÉRATION ---

// Vérification de la session (basé sur le user_id de votre système, ici idClient)
if (!isset($_SESSION['idClient'])) {
    header('Location: connexion.php');
    exit();
}

$idClient = $_SESSION['idClient'];
$commandes = [];

// Connexion et Requete SQL
if (isset($connection)) {
    try {
        // CORRECTION SQL : Utilisation des bons noms de colonnes de votre BDD
        $sql = "SELECT idCommande, dateCommande, statutCommande, prixTotal 
                FROM Commande 
                WHERE idClient = :id 
                ORDER BY dateCommande DESC";
        
        $stmt = $connection->prepare($sql);
        $stmt->execute([':id' => $idClient]);
        $commandes = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
    } catch (PDOException $e) {
        $erreur = "Erreur de récupération des parchemins : " . $e->getMessage();
    }
}
?>

<div id="section-mes-commandes" class="section-content w-full py-16 px-4 bg-white min-h-[60vh]">
    <div class="max-w-7xl mx-auto">
        <h2 class="font-display text-4xl text-green-800 mb-10">📜 Historique de vos Commandes</h2>
        
        <div class="flex flex-col md:flex-row gap-8">
            
            <nav class="md:w-1/4 p-4 border rounded-xl shadow-lg bg-gray-50 h-fit">
                <ul class="space-y-2 font-medium text-lg">
                    <li><a href="monCompte.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50">🔮 Mon Tableau de Bord</a></li>
                    <li><a href="mesCommandes.php" class="block p-3 bg-green-100 text-green-700 rounded-lg hover:bg-green-200">📜 Mes Commandes</a></li>
                    <li><a href="mesInformations.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50">👤 Mes Informations</a></li>
                    <li><a href="deconnexion.php" class="block p-3 text-red-600 rounded-lg hover:bg-red-50">🚪 Déconnexion</a></li>
                </ul>
            </nav>

            <div class="md:w-3/4">
                
                <?php if (isset($erreur)): ?>
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                        <?= htmlspecialchars($erreur) ?>
                    </div>
                <?php endif; ?>

                <div class="p-6 border rounded-xl shadow-lg bg-gray-50">
                    
                    <?php if (count($commandes) > 0): ?>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Référence</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Statut</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                                    <th class="px-6 py-3"></th> 
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                
                                <?php foreach ($commandes as $cmd): 
                                    // LOGIQUE DE COULEUR SELON VOS STATUTS BDD ('payee', 'expediee', 'livree', 'annulee')
                                    $badgeClass = 'bg-gray-100 text-gray-800'; 
                                    $rowClass = 'hover:bg-gray-50';
                                    
                                    // Sécurisation de la variable statut
                                    $statut = htmlspecialchars($cmd['statutCommande']);

                                    switch($statut) {
                                        case 'livree':
                                            $badgeClass = 'bg-green-100 text-green-800';
                                            $rowClass = 'hover:bg-green-50';
                                            break;
                                        case 'expediee':
                                            $badgeClass = 'bg-blue-100 text-blue-800';
                                            $rowClass = 'hover:bg-blue-50';
                                            break;
                                        case 'payee':
                                            // Payée = En préparation généralement
                                            $badgeClass = 'bg-yellow-100 text-yellow-800';
                                            $rowClass = 'hover:bg-yellow-50';
                                            break;
                                        case 'annulee':
                                            $badgeClass = 'bg-red-100 text-red-800';
                                            $rowClass = 'hover:bg-red-50';
                                            break;
                                    }
                                ?>
                                <tr class="<?= $rowClass ?> transition-colors duration-150">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        #<?= htmlspecialchars($cmd['idCommande']) ?>
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <?= date('d/m/Y', strtotime($cmd['dateCommande'])) ?>
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <?= $badgeClass ?>">
                                            <?= ucfirst($statut) ?>
                                        </span>
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-green-700 font-semibold">
                                        <?= number_format($cmd['prixTotal'], 2, ',', ' ') ?> €
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <a href="detailCommande.php?id=<?= $cmd['idCommande'] ?>" class="text-yellow-600 hover:text-yellow-800 font-semibold">
                                            Voir détails
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                
                            </tbody>
                        </table>
                    </div>
                    <?php else: ?>
                        <div class="text-center py-10">
                            <p class="text-gray-500 text-lg mb-4">Votre inventaire de quêtes est vide (aucune commande).</p>
                            <a href="catalogue.php" class="px-4 py-2 bg-green-700 text-white rounded hover:bg-green-800 transition">Aller à la boutique</a>
                        </div>
                    <?php endif; ?>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<?php include_once 'includes/footer.php'; ?>
<?php ob_end_flush(); ?>