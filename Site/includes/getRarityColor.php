<?php
// Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    header("Location: index.php"); //On redirige vers la page
}
function getRarityColor(string $rarity): string {
    $rarity = strtolower(trim($rarity));

    return match($rarity) {
        'legendaire', 'legendary' => 'bg-yellow-500 text-white',
        'epique', 'epic'          => 'bg-purple-500 text-white',
        'rare'                   => 'bg-blue-500 text-white',
        'peu commun', 'uncommon' => 'bg-green-500 text-white',
        'commun', 'common'       => 'bg-gray-500 text-white',
        'mixte'                  => 'bg-gradient-to-r from-yellow-500 via-purple-500 via-blue-500 via-green-500 to-gray-500 text-white font-bold shadow-md',
 

        default => 'bg-gray-700 text-white' // fallback
    };
}
