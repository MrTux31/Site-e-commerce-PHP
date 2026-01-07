<?php
ob_start(); 
session_start();
require_once 'connec.inc.php'; 

// sécurité et recup id Client
if (!isset($_SESSION["SLeRoiMerlin"]) || $_SESSION["SLeRoiMerlin"] !== "OK" || !isset($_SESSION['idClient'])) {
    header('Location: connexion.php');
    exit;
}

$clientId = $_SESSION['idClient'];
$message = '';
$messageType = '';

// Mise à jour des informations personnelles 
if (isset($_POST['prenom'])) {
    
    // Validation des champs obligatoires (méthode simple)
    // Elle vérifie chaque champ un par un et s'arrête (break) au premier champ vide trouvé.
    $required = ['nom', 'prenom', 'email', 'adresse', 'code_postal', 'ville'];
    $isValid = true;
    foreach ($required as $field) {
        if (empty($_POST[$field])) {
            $isValid = false;
            break;
        }
    }
    
    if ($isValid) {
        try {
            $sql = "UPDATE Client 
                    SET nom = ?, prenom = ?, email = ?, telephone = ?, adresse = ?, codePostal = ?, ville = ? 
                    WHERE idClient = ?";
            
            $stmt = $connection->prepare($sql);
            
            $stmt->execute([
                $_POST['nom'],
                $_POST['prenom'],
                $_POST['email'],
                $_POST['tel'],
                $_POST['adresse'],
                $_POST['code_postal'],
                $_POST['ville'],
                $clientId
            ]);
            
            if ($stmt->rowCount() > 0) {
                // Mise à jour des variables de session pour le header
                $_SESSION['nomClient'] = $_POST['nom']; 
                $_SESSION['prenomClient'] = $_POST['prenom'];
                
                $message = "Informations mises à jour avec succès !";
                $messageType = 'success';
            } else {
                $message = "Aucune modification détectée.";
                $messageType = 'warning';
            }
            
        } catch (PDOException $e) {
            $message = "Erreur de base de données.";
            $messageType = 'error';
        }
    } else {
        $message = "Erreur : Tous les champs obligatoires doivent être remplis.";
        $messageType = 'error';
    }
}


// Récup données actuelles
$stmt = $connection->prepare("SELECT nom, prenom, email, telephone, adresse, codePostal, ville FROM Client WHERE idClient = ?");
$stmt->execute([$clientId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    // Harmonisation des noms et gestion des champs potentiellement vides
    $user['code_postal'] = $user['codePostal'] ?? '';
    $user['tel'] = $user['telephone'] ?? '';
} else {
    header('Location: deconnexion.php'); exit;
}

// Définition des classes de message
$messageBg = match ($messageType) {
    'success' => 'bg-green-100 text-green-800 border border-green-400',
    'warning' => 'bg-yellow-100 text-yellow-800 border border-yellow-400',
    default => 'bg-red-100 text-red-800 border border-red-400',
};
?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<body class="font-body bg-parchemin h-full">

<?php include_once 'includes/header.php'; ?>

<div id="section-mes-informations" class="section-content w-full py-16 px-4 bg-gray-50 min-h-[60vh]">
    <div class="max-w-7xl mx-auto">
        <h2 class="font-display text-4xl text-green-800 mb-10">Mes Informations Personnelles</h2>
        
        <div class="flex flex-col md:flex-row gap-8">
            
            <nav class="md:w-1/4 p-4 border rounded-xl shadow-lg bg-gray-50 h-fit">
                <ul class="space-y-2 font-medium text-lg">
                    <li><a href="monCompte.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50 transition-colors">🔮 Mon Tableau de Bord</a></li>
                    <li><a href="mesCommandes.php" class="block p-3 text-gray-700 rounded-lg hover:bg-yellow-50 transition-colors">📜 Mes Commandes</a></li>
                    <li><a href="mesInformations.php" class="block p-3 bg-green-100 text-green-700 rounded-lg hover:bg-green-200 transition-colors">👤 Mes Informations</a></li>
                    <li><a href="deconnexion.php" class="block p-3 text-red-600 rounded-lg hover:bg-red-50 transition-colors">🚪 Déconnexion</a></li>
                </ul>
            </nav>
            <div class="md:w-3/4 space-y-8">
                <?php if ($message): ?>
                    <div class="mb-6 p-4 rounded-lg <?= $messageBg ?>">
                        <?= htmlspecialchars($message) ?>
                    </div>
                <?php endif; ?>

                <div class="p-6 border rounded-xl shadow-md bg-amber-100 border-yellow-500">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="font-display text-2xl text-green-700">Mise à jour de l'Aventurier</h3>
                        <button type="button" id="btnEdit" class="bg-yellow-600 hover:bg-yellow-700 text-white px-6 py-2 rounded-lg font-semibold transition-all">
                            Modifier
                        </button>
                    </div>

                    <form id="personal-info-form" method="POST" action="">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label for="prenom" class="block text-sm font-semibold text-gray-700 mb-1">Prénom</label>
                                <input type="text" id="prenom" name="prenom" value="<?= htmlspecialchars($user['prenom'] ?? '') ?>" required readonly class="form-field w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                            </div>
                            <div>
                                <label for="nom" class="block text-sm font-semibold text-gray-700 mb-1">Nom</label>
                                <input type="text" id="nom" name="nom" value="<?= htmlspecialchars($user['nom'] ?? '') ?>" required readonly class="form-field w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="email" class="block text-sm font-semibold text-gray-700 mb-1">Email</label>
                            <input type="email" id="email" name="email" value="<?= htmlspecialchars($user['email'] ?? '') ?>" required readonly class="form-field w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                        </div>

                        <div class="mb-4">
                            <label for="tel" class="block text-sm font-semibold text-gray-700 mb-1">Téléphone</label>
                            <input type="text" id="tel" name="tel" value="<?= htmlspecialchars($user['tel'] ?? '') ?>" readonly class="form-field w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                        </div>

                        <h3 class="font-display text-xl text-green-700 mb-3 mt-6">Adresse de Livraison</h3>
                        <div class="mb-4">
                            <label for="adresse" class="block text-sm font-semibold text-gray-700 mb-1">Adresse</label>
                            <input type="text" id="adresse" name="adresse" value="<?= htmlspecialchars($user['adresse'] ?? '') ?>" required readonly class="form-field w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <input type="text" id="ville" name="ville" value="<?= htmlspecialchars($user['ville'] ?? '') ?>" placeholder="Ville" required readonly class="form-field px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                            <input type="text" id="code_postal" name="code_postal" value="<?= htmlspecialchars($user['code_postal'] ?? '') ?>" placeholder="Code Postal" required readonly class="form-field px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500 bg-gray-100 cursor-not-allowed">
                        </div>
                        
                        <div class="flex gap-4 mt-6">
                            <button type="submit" id="btnSave" class="hidden w-full bg-green-700 hover:bg-green-800 text-white rounded-lg py-3 font-semibold transition-all glow-green">
                                Enregistrer les modifications
                            </button>
                            <button type="button" id="btnCancel" class="hidden w-full bg-gray-500 hover:bg-gray-600 text-white rounded-lg py-3 font-semibold transition-all">
                                Annuler
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
const form = document.querySelector('form');
const fields = document.querySelectorAll('.form-field');
const btnEdit = document.getElementById('btnEdit');
const btnSave = document.getElementById('btnSave');
const btnCancel = document.getElementById('btnCancel');
const originalValues = {};

fields.forEach(field => {
    originalValues[field.name] = field.value;
});

// Activation du mode édition
btnEdit.onclick = () => {
    fields.forEach(field => {
        field.removeAttribute('readonly');
        field.classList.remove('bg-gray-100', 'cursor-not-allowed');
        field.classList.add('bg-white', 'border-yellow-500');
    });
    btnEdit.classList.add('hidden');
    btnSave.classList.remove('hidden');
    btnCancel.classList.remove('hidden');
};

// Annulation du mode édition
btnCancel.onclick = () => {
    fields.forEach(field => {
        field.value = originalValues[field.name];
        field.setAttribute('readonly', 'readonly');
        field.classList.add('bg-gray-100', 'cursor-not-allowed');
        field.classList.remove('bg-white', 'border-yellow-500');
    });
    btnEdit.classList.remove('hidden');
    btnSave.classList.add('hidden');
    btnCancel.classList.add('hidden');
};

// Retirer readonly avant la soumission pour envoyer les données
form.onsubmit = () => {
    fields.forEach(field => {
        field.removeAttribute('readonly');
    });
    return true;
};
</script>

<?php include_once 'includes/footer.php'; ?>
<?php ob_end_flush(); ?>