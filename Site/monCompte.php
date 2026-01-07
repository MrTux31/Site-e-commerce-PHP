<?php 

ob_start(); 
?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<?php include_once 'includes/utils.php'; ?>
<body class="font-body bg-parchemin h-full">

<?php 
include_once 'includes/header.php'; 
if (isset($_GET['msgErreur'])) { //Si message erreur présent on l'affiche
    afficherMessage($_GET['msgErreur'], 'erreur');
    } else if (isset($_GET['msgSucces'])) { //Si message succes présent on l'affiche
    afficherMessage($_GET['msgSucces'], 'succes');
}

    


// --- LOGIQUE PHP : RECUPERATION DES DONNEES ---

// 1. Initialisation des variables par défaut (pour éviter les erreurs d'affichage)
$pointsFidelite = 0;
$nbCommandes = 0;
$lastOrder = null;
$prenom = "Aventurier";
$nom = "";

// 2. Vérification de la connexion
// On vérifie si $connection (de header.php) existe et si l'utilisateur est connecté
if (isset($_SESSION['idClient']) && isset($connection)) {
    
    $id = $_SESSION['idClient'];

    try {
        // A. Récupérer les infos client (Points fidélité, Nom, Prénom)
        // On rafraîchit les infos depuis la BDD au cas où elles ont changé
        $sqlClient = "SELECT ptsFidelite, nom, prenom FROM Client WHERE idClient = :id";
        $stmt = $connection->prepare($sqlClient);
        $stmt->execute([':id' => $id]);
        $clientInfo = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($clientInfo) {
            $pointsFidelite = $clientInfo['ptsFidelite'];
            $prenom = htmlspecialchars($clientInfo['prenom']);
            $nom = htmlspecialchars($clientInfo['nom']);
        }

        // B. Compter le nombre total de commandes
        $sqlCount = "SELECT COUNT(*) as total FROM Commande WHERE idClient = :id";
        $stmt = $connection->prepare($sqlCount);
        $stmt->execute([':id' => $id]);
        $resCount = $stmt->fetch(PDO::FETCH_ASSOC);
        $nbCommandes = $resCount['total'] ?? 0;

        // C. Récupérer la dernière commande
        $sqlLast = "SELECT idCommande, statutCommande, dateCommande 
                    FROM Commande 
                    WHERE idClient = :id 
                    ORDER BY dateCommande DESC 
                    LIMIT 1";
        $stmt = $connection->prepare($sqlLast);
        $stmt->execute([':id' => $id]);
        $lastOrder = $stmt->fetch(PDO::FETCH_ASSOC);

    } catch (PDOException $e) {
        echo "<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative'>Erreur SQL : " . $e->getMessage() . "</div>";
    }
} else {
    $erreur = "Vous devez être connecté pour accéder à cette page.";
    header("Location: connexion.php?msgErreur=".urlencode($erreur)); 
    exit();
}
?>

<div id="section-mon-compte" class="section-content w-full py-16 px-4 bg-white min-h-[60vh]">
    <div class="max-w-7xl mx-auto">
        <h2 class="font-display text-4xl text-green-800 mb-10">Tableau de Bord de l'Aventurier</h2>
        
        <div class="flex flex-col md:flex-row gap-8">
            
            <nav class="md:w-1/4 p-4 border rounded-xl shadow-lg bg-gray-50 h-fit">
                <ul class="space-y-2 font-medium text-lg">
                    <li><a href="monCompte.php" class="block p-3 bg-green-100 text-green-700 rounded-lg hover:bg-green-200">🔮 Mon Tableau de Bord</a></li>
                    <li><a href="mesCommandes.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50">📜 Mes Commandes</a></li>
                    <li><a href="mesInformations.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50">👤 Mes Informations</a></li>
                    <li><a href="deconnexion.php" class="block p-3 text-red-600 rounded-lg hover:bg-red-50">🚪 Déconnexion</a></li>
                </ul>
            </nav>
            
            <div class="md:w-3/4 space-y-8">
                
                <div class="p-6 border rounded-xl shadow-md bg-yellow-50 border-yellow-500">
                    <h3 class="font-display text-2xl text-green-700 mb-3">
                        Bienvenue, <span class="text-yellow-700"><?= $prenom . ' ' . $nom ?></span> !
                    </h3>
                    <p class="text-gray-700">C'est ici que vous gérez vos sorts, vos achats et vos informations personnelles.</p>
                </div>
                
                <div class="p-6 border rounded-xl shadow-md bg-white">
                    <h3 class="font-display text-2xl text-green-700 mb-4">Dernières Activités</h3>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
                        
                        <div class="p-4 border rounded-lg bg-green-50">
                            <p class="text-3xl font-bold text-green-800"><?= $nbCommandes ?></p>
                            <p class="text-sm text-gray-600">Commandes Passées</p>
                        </div>
                        
                        <div class="p-4 border rounded-lg bg-yellow-50">
                            <p class="text-3xl font-bold text-yellow-700"><?= $pointsFidelite ?></p>
                            <p class="text-sm text-gray-600">Points de Magie (Fidélité)</p>
                        </div>
                        
                        <div class="p-4 border rounded-lg bg-gray-50">
                            <?php if ($lastOrder): ?>
                                <p class="text-lg font-semibold text-gray-800">Commande #<?= $lastOrder['idCommande'] ?></p>
                                <p class="text-sm text-green-600">
                                    <?= ucfirst($lastOrder['statutCommande']) ?>
                                </p>
                                <p class="text-xs text-gray-500 mt-1">
                                    Du <?= date('d/m/Y', strtotime($lastOrder['dateCommande'])) ?>
                                </p>
                            <?php else: ?>
                                <p class="text-lg font-semibold text-gray-800">Aucune commande</p>
                                <p class="text-sm text-gray-500">Lancez-vous !</p>
                            <?php endif; ?>
                        </div>
                    </div>
                    
                    <div class="mt-6 text-center">
                        <a href="mesCommandes.php" class="inline-block bg-yellow-500 hover:bg-yellow-600 text-green-900 px-6 py-3 rounded-full font-semibold transition-all">Voir toutes mes commandes</a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<?php include_once 'includes/footer.php'; ?>
<?php ob_end_flush(); ?>