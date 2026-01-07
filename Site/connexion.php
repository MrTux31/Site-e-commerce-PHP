<?php 
// Activation du buffering pour gérer les inclusions PHP
ob_start(); 
// Activation session 
session_start();

if (isset($_SESSION["idClient"]) || isset($_SESSION["idAdmin"])) {
    // Si c'est un admin, on le redirige vers son dashboard, sinon vers son compte
    $redirect = isset($_SESSION["idAdmin"]) ? "admin/tableauBord.php" : "monCompte.php";
    // On redirige avec un message pour expliquer pourquoi l'accès est bloqué
    header("Location: " . $redirect . "?msgErreur=" . urlencode("Vous êtes déjà connecté. Veuillez vous déconnecter pour utiliser un autre compte."));
    exit();
}

?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<body class="font-body bg-parchemin h-full">

<?php include_once 'includes/header.php'; ?>

<div id="section-connexion" class="section-content w-full py-16 px-4">
    <div class="max-w-xl mx-auto p-8 border border-gray-200 rounded-2xl shadow-2xl bg-white">
        <h2 class="font-display text-4xl text-green-800 text-center mb-8" id="auth-title">Connexion des Aventuriers</h2>
        <?php if (isset($_GET['msgErreur'])): ?>
    <div class="mb-4 p-3 rounded-lg bg-red-100 border border-red-300 text-red-700 text-center">
        <?= htmlspecialchars($_GET['msgErreur']) ?>
    </div>
<?php endif; ?>
        <?php if (isset($_GET['msgSucces'])): ?>
    <div class="mb-4 p-3 rounded-lg bg-green-100 border border-green-300 text-green-700 text-center">
        <?= htmlspecialchars($_GET['msgSucces']) ?>
    </div>
<?php endif; ?>

        <div id="auth-tabs" class="flex justify-center mb-8 border-b border-gray-200">
            <button id="tab-login" class="px-6 py-2 text-lg font-semibold border-b-4 border-green-700 text-green-700 transition-all">Se Connecter</button>
            <button id="tab-register" class="px-6 py-2 text-lg font-semibold border-b-4 border-transparent text-gray-500 hover:text-green-700 transition-all">Créer un Compte</button>
        </div>

       <form id="login-form" action="traitConnexion.php" method="post" class="space-y-6">
    <div>
        <label for="login-email" class="block text-sm font-medium text-gray-700 mb-1">E-mail</label>
        <input type="email" id="login-email" name="login" required
               class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
    </div>
    <div>
        <label for="login-password" class="block text-sm font-medium text-gray-700 mb-1">Mot de Passe</label>
        <input type="password" id="login-password" name="login-password" required
               class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
    </div>
    <div class="flex items-center justify-between">
        <div class="flex items-center">
            <input id="remember-me" name="remember-me" type="checkbox"
                   class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
            <label for="remember-me" class="ml-2 block text-sm text-gray-900">Se souvenir de moi</label>
        </div>
         <!--<a href="#" class="text-sm font-medium text-yellow-600 hover:text-yellow-700">Oublié le mot de passe ?</a>-->
    </div>
    <button type="submit"
            class="w-full bg-green-700 hover:bg-green-800 text-white rounded-lg py-3 font-semibold transition-all glow-green">
        Se Connecter
    </button>
</form>


        <form id="register-form" action="traitInscription.php" method="post" class="space-y-6 hidden">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="register-prenom" class="block text-sm font-medium text-gray-700 mb-1">Prénom</label>
                    <input type="text" id="register-prenom" name="prenom" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
                <div>
                    <label for="register-nom" class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
                    <input type="text" id="register-nom" name="nom" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
            </div>
            <div class="grid grid-cols-1 gap-4">
                <div>
                    <label for="register-email" class="block text-sm font-medium text-gray-700 mb-1">E-mail</label>
                    <input type="email" id="register-email" name="email" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
                <div>
                    <label for="register-password" class="block text-sm font-medium text-gray-700 mb-1">Mot de Passe</label>
                    <input type="password" id="register-password" name="motDePasse" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
                <div>
                    <label for="register-confirm-password" class="block text-sm font-medium text-gray-700 mb-1">Confirmer le Mot de Passe</label>
                    <input type="password" id="register-confirm-password" name="confirmation" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
                <div>
                    <label for="register-adresse" class="block text-sm font-medium text-gray-700 mb-1">Adresse</label>
                    <input type="text" id="register-adresse" name="adresse" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="md:col-span-1">
                        <label for="register-codepostal" class="block text-sm font-medium text-gray-700 mb-1">Code Postal</label>
                        <input type="text" id="register-codepostal" name="codePostal" maxlength="10" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                    </div>
                    <div class="md:col-span-2">
                        <label for="register-ville" class="block text-sm font-medium text-gray-700 mb-1">Ville</label>
                        <input type="text" id="register-ville" name="ville" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                    </div>
                </div>
                <div>
                    <label for="register-telephone" class="block text-sm font-medium text-gray-700 mb-1">Téléphone (optionnel)</label>
                    <input type="tel" id="register-telephone" name="telephone" pattern="[0-9]{10}" maxlength="10" class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500" placeholder="0601020304">
                </div>
            </div>
            <button type="submit" class="w-full bg-yellow-500 hover:bg-yellow-600 text-green-900 rounded-lg py-3 font-semibold transition-all glow-gold"> Créer le Compte </button>
        </form>
    </div>
</div>

<?php include_once 'includes/footer.php'; ?>
<?php ob_end_flush(); ?>