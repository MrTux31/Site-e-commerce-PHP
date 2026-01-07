<?php 
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
require_once dirname(__DIR__) . '/connec.inc.php'; 

require_once "./includes/utils.php"; 

//Cookie panier : 
// Calcul des quantites du panier et nettoyage du panier
$nbArticlesPanier = 0;
$panier = [];
if (isset($_COOKIE['panier'])) {
    $panier = json_decode($_COOKIE['panier'], true);

    if (is_array($panier)){
        nettoyerPanier($panier); //On enlève du panier tous les produits qui ne sont plus en stock / mise a jour de la qte max par rapport au stock
        //Mettre à jour le cookie (on enregistre en json), 14 jours
        setcookie('panier', json_encode($panier), time() + (14 * 24 * 60 * 60), '/');
        foreach ($panier as $qte){
            $nbArticlesPanier += (int)$qte;
        }
    }
}

// --- 1. SÉCURITÉ ABSOLUE : VERIFICATION DU TEMPS ---
if (isset($_SESSION['heure_expiration_stricte']) && time() > $_SESSION['heure_expiration_stricte']) {
    $_SESSION = [];
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $params["path"], $params["domain"], $params["secure"], $params["httponly"]);
    }
    session_destroy();
    header("Location: connexion.php?msgErreur=" . urlencode("Votre session a expiré (Temps écoulé)."));
    exit();
}

// --- 2. RECONNEXION AUTO SÉCURISÉE (TOKEN) ---
if (!isset($_SESSION["idClient"]) && !isset($_SESSION["idAdmin"]) && isset($_COOKIE["CLeRoiMerlin"])) {
    $cookieValue = $_COOKIE["CLeRoiMerlin"];
    $parts = explode(':', $cookieValue);

    if (count($parts) === 2) {
        $selector = $parts[0];
        $validator = $parts[1];

        if (isset($connection)) {
            $stmt = $connection->prepare("SELECT * FROM auth_tokens WHERE selector = ? AND expires_at > NOW()");
            $stmt->execute([$selector]);
            $tokenData = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($tokenData && isset($tokenData['token']) && hash_equals($tokenData['token'], hash('sha256', $validator))) {
                
                if ($tokenData['user_type'] === 'admin') {
                    $stmtAdmin = $connection->prepare("SELECT idAdmin, nomAdmin, prenomAdmin FROM Administrateur WHERE idAdmin = ?");
                    $stmtAdmin->execute([$tokenData['user_id']]);
                    $admin = $stmtAdmin->fetch(PDO::FETCH_ASSOC);
                    if ($admin) {
                        $_SESSION["SLeRoiMerlin"] = "OK";
                        $_SESSION["idAdmin"] = $admin['idAdmin'];
                        $_SESSION["nomAdmin"] = $admin['nomAdmin'];
                        $_SESSION["prenomAdmin"] = $admin['prenomAdmin'];
                        
                        //On réinitialise le temps d'expiration stricte
                        $_SESSION['heure_expiration_stricte'] = time() + 3600; 
                    }
                } else {
                    $stmtUser = $connection->prepare("SELECT idClient, nom, prenom FROM Client WHERE idClient = ?");
                    $stmtUser->execute([$tokenData['user_id']]);
                    $clientTrouve = $stmtUser->fetch(PDO::FETCH_ASSOC);
                    if ($clientTrouve) {
                        $_SESSION["SLeRoiMerlin"] = "OK";
                        $_SESSION["idClient"] = $clientTrouve['idClient'];
                        $_SESSION["prenomClient"] = $clientTrouve['prenom'];
                        $_SESSION["nomClient"] = $clientTrouve['nom'];
                        
                        //On réinitialise le temps d'expiration stricte
                        $_SESSION['heure_expiration_stricte'] = time() + 3600;
                    }
                }
            } else {
                // Si le token est invalide ou expiré, on supprime le cookie pour éviter de reboucler
                setcookie("CLeRoiMerlin", "", time() - 3600, "/");
            }
        }
    }
}

// --- 3. VERIFICATION DE LA DISPARITION DU COOKIE ---
if ((isset($_SESSION["idClient"]) || isset($_SESSION["idAdmin"])) && isset($_SESSION['heure_expiration_stricte']) && empty($_COOKIE["CLeRoiMerlin"])) {
    $_SESSION = [];
    session_destroy();
    header("Location: connexion.php?msgErreur=" . urlencode("Session expirée."));
    exit;
}

// Variables d'affichage
$estConnecte = false;
$affichageNom = "";
$lienCompte = "connexion.php";

if (isset($_SESSION["idAdmin"])) {
    $estConnecte = true;
    $affichageNom = htmlspecialchars($_SESSION["prenomAdmin"]);
    $lienCompte = "admin/tableauBord.php"; // Redirection vers le tableau de bord Admin
} elseif (isset($_SESSION["idClient"])) {
    $estConnecte = true;
    $affichageNom = htmlspecialchars($_SESSION["prenomClient"]);
    $lienCompte = "monCompte.php"; // Redirection vers le compte Client
}
?>

<header class="sticky top-0 z-40 bg-white shadow-lg">
    <div class="w-full px-4 py-3">
        <div class="flex items-center justify-between max-w-7xl mx-auto gap-4">
            <a href="index.php" class="flex items-center gap-3 cursor-pointer">
                <img src="images/logo.png" alt="Logo" class="w-20 h-20 mx-auto mb-4 rounded-3xl">
                <div>
                    <h1 class="font-display text-2xl text-green-800" id="store-name">Le Roi Merlin</h1>
                    <p class="text-xs text-gray-600">Artisanat Magique</p>
                </div>
            </a>

            <div class="hidden md:flex items-center flex-1 max-w-2xl mx-8">
                <div class="relative w-full">
                    <form method="GET" action="traitRecherche.php" id="search-form" class="relative w-full">
                        <input 
                            type="text"
                            name="search"
                            id="search-input"
                            value="<?= htmlspecialchars($_GET['search'] ?? '') ?>"
                            placeholder="Rechercher un artefact..."
                            class="w-full px-4 py-2 pr-10 rounded-full border-2 border-green-700 focus:outline-none focus:border-yellow-500 transition-all">
                        
                        <button type="submit" id="search-btn" class="absolute right-2 top-1/2 transform -translate-y-1/2 text-green-700">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </button>
                    </form>
                </div>
            </div>
            <nav class="flex items-center gap-6">
                <a href="index.php" class="hidden md:block text-gray-700 hover:text-green-700 transition-all font-medium">Accueil</a>
                <a href="catalogue.php" class="hidden md:block text-gray-700 hover:text-green-700 transition-all font-medium">Catalogue</a> 
                
                <a href="<?= $lienCompte ?>" class="hidden md:block text-gray-700 hover:text-green-700 transition-all font-medium">
                    <?php if ($estConnecte): ?>
                        <?= (isset($_SESSION["idAdmin"]) ? "Dashboard" : "Mon Compte") . " ($affichageNom)" ?>
                    <?php else: ?>
                        Se connecter
                    <?php endif; ?>
                </a>

                <a href="panier.php">
                    <button id="cart-btn" class="relative p-2 rounded-full hover:bg-green-50 transition-all">
                        <svg class="w-6 h-6 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                        <span id="cart-count" class="absolute -top-1 -right-1 bg-yellow-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center font-bold"><?= $nbArticlesPanier ?></span> 
                    </button>
                </a>
            </nav>
        </div>
    </div>

    <div class="border-t border-gray-200 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 py-2">
            <div class="flex items-center gap-6 overflow-x-auto text-sm">
                <a href="catalogue.php"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">Tous</button></a>
                <a href="catalogue.php?category=1"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">⚔️ Armes</button></a> 
                <a href="catalogue.php?category=22"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">🧪 Alchimie & Potions</button></a> 
                <a href="catalogue.php?category=16"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">🪄 Catalyseurs Magiques</button></a>
                <a href="catalogue.php?category=62"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">🎁 Kits & Coffrets</button></a>
                <a href="catalogue.php?category=64"><button class="category-btn whitespace-nowrap px-3 py-1 rounded-full hover:bg-green-100 transition-all">📚 Culture & Divertissement</button></a>
            </div>
        </div>
    </div>
</header>