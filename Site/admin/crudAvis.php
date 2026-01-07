<?php
// On démarre la session pour accéder aux variables globales ($_SESSION)
session_start();
// Import du fichier de connexion à la base de données (contenant l'objet $connection)
require_once "../connec.inc.php";

// SÉCURITÉ : On vérifie si l'utilisateur est un administrateur connecté.
// Si l'ID admin n'existe pas en session, on le renvoie vers la page de connexion.
if (!isset($_SESSION["idAdmin"])) {
    header("Location: ../connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

$pdo = $connection; // Utilisation de l'alias $pdo pour plus de clarté
$avisList = [];
$errorMsg = "";

try {
    // --- GESTION DES ACTIONS (Quand l'admin clique sur un bouton "Envoyer" ou "Supprimer") ---
    if ($_SERVER["REQUEST_METHOD"] == "POST") {

        // CAS 1 : L'ADMIN RÉPOND À UN AVIS
        if (isset($_POST['action_reply'])) {
            $idAvis = intval($_POST['idAvis']); // On force l'ID en entier pour la sécurité
            $reponseTxt = trim($_POST['reponse']); // On nettoie les espaces vides autour du texte

            if (!empty($reponseTxt)) {
                // SÉCURITÉ : On vérifie si une réponse n'a pas déjà été enregistrée pour cet avis
                $stmt = $pdo->prepare("SELECT 1 FROM ReponseAvis WHERE idAvis = ?");
                $stmt->execute([$idAvis]);
                if ($stmt->fetch()) {
                    header("Location: crudAvis.php?msgErreur=" . urlencode("Une réponse existe déjà pour cet avis."));
                    exit;
                }

                // Insertion de la réponse officielle liée à l'admin connecté
                $stmt = $pdo->prepare("INSERT INTO ReponseAvis (idAdmin, idAvis, reponse, date) VALUES (?, ?, ?, NOW())");
                $stmt->execute([$_SESSION['idAdmin'], $idAvis, $reponseTxt]);

                header("Location: crudAvis.php?msgSucces=" . urlencode("La réponse a été envoyée avec succès !"));
                exit;
            } else {
                header("Location: crudAvis.php?msgErreur=" . urlencode("Le texte de la réponse ne peut pas être vide."));
                exit;
            }
        }

        // CAS 2 : L'ADMIN SUPPRIME UN AVIS
        if (isset($_POST['action_delete'])) {
            $idToDelete = intval($_POST['idAvisDelete']);
            try {
                // TRANSACTION SQL : On s'assure que TOUT est supprimé (avis + photos + réponses).
                // Si l'une des requêtes échoue, le rollback annule tout pour éviter les données orphelines.
                $pdo->beginTransaction();
                
                // Suppression par étapes pour respecter les contraintes de clés étrangères
                $pdo->prepare("DELETE FROM ReponseAvis WHERE idAvis = ?")->execute([$idToDelete]);
                $pdo->prepare("DELETE FROM PhotoAvis WHERE idAvis = ?")->execute([$idToDelete]);
                $pdo->prepare("DELETE FROM Avis WHERE idAvis = ?")->execute([$idToDelete]);
                
                $pdo->commit(); // Validation finale de la suppression
                header("Location: crudAvis.php?msgSucces=" . urlencode("L'avis a été supprimé avec succès."));
                exit;
            } catch (PDOException $e) {
                if ($pdo->inTransaction()) $pdo->rollBack(); 
                header("Location: crudAvis.php?msgErreur=" . urlencode("Erreur inattendue lors de la suppression."));
                exit;
            }
        }
    }

    // --- RÉCUPÉRATION DES DONNÉES (SQL) ---
    // GROUP_CONCAT : Regroupe les URLs des photos en une seule chaîne séparée par des virgules.
    // LEFT JOIN : Permet d'afficher l'avis même s'il n'y a pas encore de réponse ou de photo associée.
    $query = "
        SELECT a.idAvis, a.note, a.commentaire, a.dateAvis, a.idClient, a.idDeclinaisonProduit,
               c.nom, c.prenom, r.reponse as texteReponse, p.libelle as nomProduit, 
               dp.libelleDeclinaison, dp.idDeclinaison,
               GROUP_CONCAT(pa.url SEPARATOR ',') as photosUrls
        FROM Avis a
        LEFT JOIN Client c ON a.idClient = c.idClient
        LEFT JOIN ReponseAvis r ON a.idAvis = r.idAvis
        LEFT JOIN DeclinaisonProduit dp ON a.idDeclinaisonProduit = dp.idDeclinaison
        LEFT JOIN Produit p ON dp.idProduit = p.idProduit
        LEFT JOIN PhotoAvis pa ON a.idAvis = pa.idAvis
        GROUP BY a.idAvis, a.note, a.commentaire, a.dateAvis, a.idClient, a.idDeclinaisonProduit,
                 c.nom, c.prenom, r.reponse, p.libelle, dp.libelleDeclinaison, dp.idDeclinaison
        ORDER BY r.reponse IS NOT NULL, a.dateAvis DESC"; // Affiche les avis non traités en premier
        
    $avisList = $pdo->query($query)->fetchAll(PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    $errorMsg = "Erreur technique lors de la récupération des données.";
}

// Fonction de formatage pour transformer la note numérique en étoiles (ex: 5 -> ★★★★★)
function displayStars($note) {
    return str_repeat("★", (int)$note) . str_repeat("☆", 5 - (int)$note);
}
?>
<!doctype html>
<html lang="fr" class="h-full">
<head>
    <?php if (file_exists('../includes/head.php')) { include_once '../includes/head.php'; } 
    else { echo '<meta charset="UTF-8"><script src="https://cdn.tailwindcss.com"></script>'; } ?>
</head>
<body class="font-body bg-[#F5F5DC] h-full flex overflow-hidden">

    <?php include_once __DIR__ . '/../includes/navAdmin.php'; ?>

    <main class="flex-1 flex flex-col h-full overflow-hidden relative z-10">
        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8 shadow-sm">
            <h2 class="text-2xl font-display font-bold text-green-900">Modération des Avis</h2>
        </header>

        <div class="flex-1 overflow-y-auto p-8">
            
            <?php if ($errorMsg || isset($_GET['msgErreur'])): ?>
                <div class="bg-red-50 border border-red-400 text-red-800 p-4 mb-6 rounded-xl shadow">
                    <?= htmlspecialchars($errorMsg ?: $_GET['msgErreur']) ?>
                </div>
            <?php elseif (isset($_GET['msgSucces'])): ?>
                <div class="bg-green-50 border border-green-400 text-green-800 p-4 mb-6 rounded-xl shadow">
                    <?= htmlspecialchars($_GET['msgSucces']) ?>
                </div>
            <?php endif; ?>

            <div class="space-y-6">
                <?php foreach ($avisList as $avis): ?>
                    <div class="bg-[#FAF9F0] border border-yellow-600/30 rounded-xl p-6 shadow-lg relative group transition-all">
                        
                        <form method="POST" class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                            <input type="hidden" name="idAvisDelete" value="<?= $avis['idAvis'] ?>">
                            <button type="submit" name="action_delete" onclick="return confirm('Confirmer la suppression définitive ?')" class="text-red-600 hover:text-red-800 font-bold text-[10px] uppercase">
                                Supprimer
                            </button>
                        </form>

                        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                            <div class="md:col-span-1 border-r border-yellow-600/10 pr-4">
                                <h4 class="text-lg font-bold text-green-900">
                                    <?= htmlspecialchars(($avis['prenom'] ?? '') . ' ' . ($avis['nom'] ?? 'Anonyme')) ?>
                                </h4>
                                <p class="text-[10px] text-gray-500 mb-3 italic">
                                    Le <?= date('d/m/Y à H:i', strtotime($avis['dateAvis'])) ?>
                                </p>
                                <div class="text-yellow-600 text-xl mb-3 tracking-tighter">
                                    <?= displayStars($avis['note']) ?>
                                </div>
                                <a href="../consultProduit.php?id=<?= $avis['idDeclinaison'] ?>" class="block hover:scale-105 transition-transform">
                                    <div class="p-2 bg-white/60 border border-yellow-600/20 rounded text-xs">
                                        <span class="block font-bold text-yellow-800 uppercase text-[9px]">Produit :</span>
                                        <span class="text-green-800 font-medium"><?= htmlspecialchars($avis['libelleDeclinaison'] ?? 'N/A') ?></span>
                                    </div>
                                </a>
                            </div>

                            <div class="md:col-span-3 flex flex-col justify-between">
                                <div class="bg-white/40 p-4 rounded-lg italic text-gray-700 border border-yellow-600/10 text-sm leading-relaxed">
                                    "<?= !empty($avis['commentaire']) ? nl2br(htmlspecialchars($avis['commentaire'])) : '<span class="text-gray-400">Aucun commentaire rédigé.</span>' ?>"
                                </div>

                                <?php if (!empty($avis['photosUrls'])): ?>
                                    <div class="flex flex-wrap gap-2 mt-4">
                                        <?php foreach (explode(',', $avis['photosUrls']) as $url): ?>
                                            <a href="<?= htmlspecialchars($url) ?>" target="_blank">
                                                <img src="<?= htmlspecialchars($url) ?>" class="w-16 h-16 object-cover rounded border border-yellow-600/30 hover:opacity-80 transition shadow-sm">
                                            </a>
                                        <?php endforeach; ?>
                                    </div>
                                <?php endif; ?>

                                <div class="mt-4 flex justify-end">
                                    <?php if ($avis['texteReponse']): ?>
                                        <div class="w-full bg-green-50/50 p-3 rounded border-l-4 border-green-700 text-sm">
                                            <p class="text-[10px] font-bold text-green-800 uppercase mb-1">Votre réponse :</p>
                                            <p class="text-gray-800 italic"><?= htmlspecialchars($avis['texteReponse']) ?></p>
                                        </div>
                                    <?php else: ?>
                                        <button onclick='openModal(<?= $avis['idAvis'] ?>)' class="bg-[#1A4D2E] text-yellow-400 px-6 py-2 rounded border border-yellow-600 hover:bg-green-900 font-bold text-xs uppercase transition shadow-md">
                                            Répondre
                                        </button>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    </main>

    <div id="replyModal" class="fixed inset-0 bg-black/70 hidden items-center justify-center p-4 z-50 backdrop-blur-sm">
        <div class="bg-[#FAF9F0] w-full max-w-lg rounded-xl border-2 border-yellow-600 shadow-2xl">
            <div class="p-6 border-b border-yellow-600/20 flex justify-between items-center">
                <h3 class="text-xl font-bold text-green-900 uppercase">Rédiger une réponse</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-red-600">×</button>
            </div>
            <div class="p-6">
                <form method="POST" class="space-y-4">
                    <input type="hidden" name="action_reply" value="1">
                    <input type="hidden" name="idAvis" id="modalIdAvis">
                    <textarea name="reponse" rows="5" required
                        class="w-full bg-white border border-yellow-600/30 p-3 rounded-lg text-sm text-green-900 focus:outline-none focus:ring-1 focus:ring-yellow-500"
                        placeholder="Réponse courtoise et professionnelle..."></textarea>
                    <div class="flex justify-end gap-3 pt-4">
                        <button type="button" onclick="closeModal()" class="text-green-800 font-bold text-xs uppercase">Annuler</button>
                        <button type="submit" class="px-8 py-2 bg-[#1A4D2E] text-yellow-400 font-bold rounded hover:bg-green-900 transition-all text-xs uppercase">Envoyer la réponse</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Fonctions JavaScript pour piloter la fenêtre modale
        function openModal(id) {
            document.getElementById('modalIdAvis').value = id;
            const modal = document.getElementById('replyModal');
            modal.classList.remove('hidden'); // Affiche la modale
            modal.classList.add('flex');
        }
        function closeModal() {
            const modal = document.getElementById('replyModal');
            modal.classList.add('hidden'); // Cache la modale
            modal.classList.remove('flex');
        }
    </script>
</body>
</html>