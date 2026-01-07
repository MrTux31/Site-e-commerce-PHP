<?php 
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header("Location: index.php"); //On redirige vers la page
}

// On récupère le nom du fichier actuel
$currentPage = basename($_SERVER['PHP_SELF']);

// On récupère le prénom de l'admin pour l'affichage
$prenomAdmin = $_SESSION['prenomAdmin'] ?? 'Admin';

// Styles CSS pour l'état actif et inactif
$activeClass = "bg-green-900 border-l-4 border-yellow-500 text-yellow-400 font-semibold";
$inactiveClass = "hover:bg-green-900 hover:text-yellow-200 transition-colors";
?>

<aside class="w-64 bg-green-950 text-yellow-50 flex flex-col shadow-2xl z-20">
    <div class="p-6 flex items-center justify-center border-b border-green-800">
        <div class="text-center">
            <div class="w-16 h-16 bg-white rounded-full mx-auto mb-2 flex items-center justify-center p-1">
                 <img src="../images/logo.png" alt="Merlin" class="rounded-full">
            </div>
            <h1 class="font-display text-xl text-yellow-400">Le Roi Merlin</h1>
            <p class="text-xs text-green-300 uppercase tracking-widest"><?php echo htmlspecialchars($prenomAdmin); ?></p>
        </div>
    </div>

    <nav class="flex-1 overflow-y-auto py-4">
        <ul class="space-y-1">
            <li>
                <a href="tableauBord.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'tableauBord.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
                    Tableau de Bord
                </a>
            </li>
            <li>
                <a href="crudProduit.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudProduit.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                    Produits
                </a>
            </li>
            <li>
                <a href="crudCateg.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudCateg.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                    Catégories
                </a>
            </li>
            <li>
                <a href="crudRegroupement.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudRegroupement.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    Regroupements
                </a>
            </li>
            <li>
                <a href="crudKit.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudKit.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4M12 12v.01M12 12h.01"></path></svg>
                    Kits & Coffrets
                </a>
            </li>
            <li>
                <a href="crudCommande.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudCommande.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    Commandes
                </a>
            </li>
            <li>
                <a href="crudAvis.php" class="flex items-center px-6 py-3 <?php echo ($currentPage == 'crudAvis.php') ? $activeClass : $inactiveClass; ?>">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg>
                    Avis
                </a>
            </li>
        </ul>
    </nav>

    <div class="p-4 border-t border-green-800">
        <a href="../deconnexion.php" class="flex items-center text-sm text-green-400 hover:text-white transition-colors">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
            Déconnexion
        </a>
    </div>
</aside>