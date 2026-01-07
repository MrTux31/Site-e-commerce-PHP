<?php
// Activation du buffering pour gérer les inclusions PHP
ob_start();
session_start();
require_once 'connec.inc.php';

// Pré-remplissage des infos du client connecté
$client = [
    'prenom' => '',
    'nom' => '',
    'email' => '',
    'adresse' => '',
    'codePostal' => '',
    'ville' => '',
    'ptsFidelite' => ''
];

if (isset($_SESSION['idClient'])) {
    try {
        $stmtClient = $connection->prepare("
            SELECT prenom, nom, email, adresse, codePostal, ville, ptsFidelite
            FROM Client
            WHERE idClient = :idClient
        ");
        $stmtClient->bindParam(':idClient', $_SESSION['idClient'], PDO::PARAM_INT);
        $stmtClient->execute();
        $rowClient = $stmtClient->fetch(PDO::FETCH_ASSOC);
        if ($rowClient) {
            $client = array_merge($client, $rowClient);
        }
    } catch (PDOException $e) {
        error_log('Préremplissage client échec : ' . $e->getMessage());
    }
} // L'utilisateur n'est pas connecté 
else {
    header('Location: connexion.php?msgErreur=' . urlencode('Vous devez être connecté pour passer commande.'));
    exit;
}




if (!isset($_SESSION['panier']) || empty($_SESSION['panier'])) {
    header('Location: panier.php?msgErreur=' . urlencode('Aucun article à commander.'));
    exit;
}


$tab_achat = $_SESSION['panier'];

// Calcul du sous total de la commande
$sousTotal = 0;
foreach ($tab_achat as $item) {
    $sousTotal += floatval($item['prix']) * intval($item['quantite']);
}



$total = $sousTotal;

?>
<!doctype html>
<html lang="fr" class="h-full">
<?php include_once 'includes/head.php'; ?>
<body class="font-body bg-parchemin h-full">

    <?php include_once 'includes/header.php'; ?>

    <div id="section-paiement" class="section-content w-full py-16 px-4 bg-white">
        <div class="max-w-7xl mx-auto">
            <?php if (isset($_GET['msgErreur'])): ?>
                <div class="mb-6">
                    <div class="bg-red-100 border border-red-400 text-red-800 px-4 py-3 rounded relative" role="alert">
                        <span class="block font-bold">Erreur</span>
                        <span class="block text-sm"><?php echo htmlspecialchars($_GET['msgErreur']); ?></span>
                    </div>
                </div>
            <?php endif; ?>

            <h2 class="font-display text-4xl text-green-800 text-center mb-12">Finaliser votre Commande</h2>
            <form method="POST" action="traitPaiement.php" id="checkout-form" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div class="lg:col-span-2 space-y-8 p-6 border border-gray-200 rounded-xl shadow-lg bg-gray-50">

                    <div>
                        <h3 class="font-display text-2xl text-green-700 mb-4 flex items-center gap-2"><span class="w-8 h-8 bg-green-700 text-white rounded-full flex items-center justify-center">1</span> Informations de Livraison</h3>
                        <div class="space-y-4">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <input type="text" id="prenom" name="prenom" placeholder="Prénom" value="<?php echo htmlspecialchars($client['prenom']); ?>" required class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                                <input type="text" id="nom" name="nom" placeholder="Nom" value="<?php echo htmlspecialchars($client['nom']); ?>" required class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                            </div>
                            <input type="email" id="email" name="email" placeholder="Adresse email" value="<?php echo htmlspecialchars($client['email']); ?>" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                            <input type="text" id="adresse" name="adresse" placeholder="Adresse complète (rue, numéro)" value="<?php echo htmlspecialchars($client['adresse']); ?>" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <input type="text" id="ville" name="ville" placeholder="Ville" value="<?php echo htmlspecialchars($client['ville']); ?>" required class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                                <input type="text" id="codePostal" name="codePostal" placeholder="Code Postal" value="<?php echo htmlspecialchars($client['codePostal']); ?>" required class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-yellow-500">
                            </div>
                        </div>
                    </div>

                    <div>
                        <h3 class="font-display text-2xl text-green-700 mb-4 flex items-center gap-2"><span class="w-8 h-8 bg-green-700 text-white rounded-full flex items-center justify-center">2</span> Méthode de Paiement</h3>
                        <div id="payment-methods" class="space-y-4">
                            <label class="flex items-center gap-4 p-4 border-2 border-yellow-500 rounded-lg bg-yellow-50 cursor-pointer">
                                <input type="radio" name="payment-method" value="CB" checked class="form-radio text-yellow-500 w-5 h-5">
                                <span class="font-semibold">Carte bancaire (CB)</span>
                            </label>

                            <label class="flex items-center gap-4 p-4 border-2 border-gray-300 rounded-lg bg-white hover:border-green-500 cursor-pointer">
                                <input type="radio" name="payment-method" value="Paypal" class="form-radio text-green-500 w-5 h-5">
                                <span class="font-semibold">PayPal</span>
                            </label>

                            <label class="flex items-center gap-4 p-4 border-2 border-gray-300 rounded-lg bg-white hover:border-green-500 cursor-pointer">
                                <input type="radio" name="payment-method" value="Virement" class="form-radio text-green-500 w-5 h-5">
                                <span class="font-semibold">Virement bancaire</span>
                            </label>

                        </div>

                        <div id="card-details" class="mt-4 p-4 border border-gray-300 rounded-lg bg-white space-y-4">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <input type="text" id="card-number" name="card-number" placeholder="Numéro de Carte" class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700">
                                <select id="card-type" name="card-type" class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg bg-white focus:outline-none focus:border-green-700">
                                    <option value="">Type de carte</option>
                                    <option value="Visa">Visa</option>
                                    <option value="Mastercard">Mastercard</option>
                                    <option value="American Express">American Express</option>
                                </select>
                            </div>
                            <div class="grid grid-cols-3 gap-4">
                                <input type="text" id="expiry-date" name="expiry-date" placeholder="MM/AA" class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700">
                                <input type="text" id="cvc" name="cvc" placeholder="CVC" class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700">
                                <input type="text" id="card-holder" name="card-holder" placeholder="Nom sur la carte" class="px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700">
                            </div>
                        </div>

                    </div>
                </div>

                <div class="lg:col-span-1 p-6 border-2 border-green-700 rounded-xl shadow-2xl bg-white sticky top-24 h-fit space-y-4">
                    <div>
                        <h3 class="font-display text-2xl text-green-800 mb-4">Récapitulatif de commande</h3>

                        <div id="payment-summary-items" class="border-b pb-4 mb-4">
                            <h4 class="text-sm font-semibold text-gray-600 uppercase tracking-wide mb-3">Articles commandés</h4>
                            <div class="space-y-3">
                                <?php foreach ($tab_achat as $item): ?>
                                    <div class="flex items-center justify-between gap-4 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                                        <div class="flex-1 min-w-0">
                                            <p class="text-sm font-medium text-gray-900 truncate">
                                                <?php echo htmlspecialchars($item['libelle']); ?>
                                            </p>
                                            <p class="text-xs text-gray-500 mt-1">
                                                <?php echo number_format(floatval($item['prix']), 2, ',', ' '); ?> € × <?php echo intval($item['quantite']); ?>
                                            </p>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <p class="text-base font-bold text-green-800">
                                                <?php echo number_format(floatval($item['prix']) * intval($item['quantite']), 2, ',', ' '); ?> €
                                            </p>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        </div>

                        <div class="space-y-2 mb-6">
                            <div class="flex justify-between text-sm text-gray-700">
                                <span>Sous-total</span>
                                <span id="recap-commande-sousTotal">
                                    <?php echo number_format($sousTotal, 2, ',', ' ') ?>
                                </span>
                            </div>
                            
                            <div class="space-y-1 pt-2 border-t border-dashed border-gray-300">
                                <div class="flex justify-between text-sm text-gray-700">
                                    <span>Points de fidélité disponibles</span>
                                    <span>
                                        <?php echo isset($client['ptsFidelite']) ? intval($client['ptsFidelite']) : 0; ?>
                                    </span>
                                </div>
                                <div class="flex flex-col text-sm text-gray-700">
                                    <label for="pointsFideliteUtilises" class="mb-1">Utiliser des points :</label>
                                    <select id="pointsFideliteUtilises" name="pointsFideliteUtilises" class="px-3 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-700">
                                        <option value="0">Ne pas utiliser de points</option>
                                        <?php $pts = isset($client['ptsFidelite']) ? intval($client['ptsFidelite']) : 0; ?>
                                        <?php if ($pts >= 10 && $sousTotal > 5): ?>
                                            <option value="10">Débiter 10 points (-5,00 €)</option>
                                        <?php endif; ?>
                                        <?php if ($pts >= 20  && $sousTotal > 10): ?>
                                            <option value="20">Débiter 20 points (-10,00 €)</option>
                                        <?php endif; ?>
                                        <?php if ($pts >= 50  && $sousTotal > 25): ?>
                                            <option value="50">Débiter 50 points (-25,00 €)</option>
                                        <?php endif; ?>
                                    </select>
                                </div>
                            </div>
                            <div class="flex justify-between text-base font-semibold text-green-800 border-t pt-2">
                                <span>Total Final</span>
                                <span id="summary-total" class="text-2xl font-bold">
                                    <?php echo number_format($total, 2, ',', ' ')."€" ?>
                                </span>
                            </div>
                        </div>
                    </div>

                    <button type="submit" id="place-order-btn" class="w-full bg-green-700 hover:bg-green-800 text-white rounded-lg py-3 font-semibold transition-all glow-green"> Confirmer & Payer <span id="final-price-btn"> <?php echo number_format($total, 2, ',', ' ') ?></span> </button>

                    <p class="text-center text-xs text-gray-500 mt-3">En cliquant sur "Confirmer & Payer", vous acceptez nos conditions générales de vente.</p>
                </div>
            </form>
        </div>
    </div>

    <?php include_once 'includes/footer.php'; ?>
    <script src="js/script.js"></script>

    <?php ob_end_flush(); ?>