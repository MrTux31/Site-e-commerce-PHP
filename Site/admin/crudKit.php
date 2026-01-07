<?php
session_start();
require_once "../connec.inc.php";

if (!isset($_SESSION["idAdmin"])) {
    header("Location: connexion.php?msgErreur=" . urlencode("Accès réservé aux administrateurs."));
    exit;
}

// --- FONCTION IMAGE ---
function traiterImageKit($idKit, $file)
{
    global $connection;
    try {
        $uploadDir = __DIR__ . '/../images/kits/';
        if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);
        $extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $nom_fichier = uniqid('kit_' . $idKit . '_') . '.' . $extension;
        $destination = $uploadDir . $nom_fichier;
        if (move_uploaded_file($file['tmp_name'], $destination)) {
            $urlWeb = 'images/kits/' . $nom_fichier;
            $connection->prepare("DELETE FROM PhotoProduit WHERE idDeclinaison = ?")->execute([$idKit]);
            $stmt = $connection->prepare("INSERT INTO PhotoProduit (idDeclinaison, url) VALUES (?, ?)");
            $stmt->execute([$idKit, $urlWeb]);
            return true;
        }
    } catch (Exception $e) {
        return false;
    }
    return false;
}

// --- LOGIQUE D'ENREGISTREMENT ---
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST['action_kit'])) {
    $idKit       = !empty($_POST['idKit']) ? (int)$_POST['idKit'] : null;
    $libelle     = trim($_POST['libelle'] ?? 'Nouveau Kit');
    $description = $_POST['description'] ?? '';
    $prix        = floatval($_POST['prix'] ?? 0);
    $prixSolde   = !empty($_POST['prixSolde']) ? floatval($_POST['prixSolde']) : null;
    $provenance  = $_POST['provenance'] ?? '';
    $qteStock    = (int)($_POST['qteStock'] ?? 1);
    $seuilQte    = (int)($_POST['seuilQte'] ?? 1);
    $produits_selectionnes = $_POST['produits'] ?? []; // Tableau des IDs cochés
    $quantites = $_POST['quantites'] ?? [];

    try {
        // --- SÉCURITÉ : VÉRIFICATION COMPOSITION VIDE ---
        if (empty($produits_selectionnes)) {
            throw new Exception("Un kit ne peut pas être vide ! Veuillez sélectionner au moins un objet.");
        }

        if ($prixSolde !== null && $prixSolde >= $prix) {
            throw new Exception("Le prix soldé doit être strictement inférieur au prix de base.");
        }

        $connection->beginTransaction();

        if ($idKit) {
            $stmt = $connection->prepare("UPDATE DeclinaisonProduit SET libelleDeclinaison=:libelle, descDeclinaison=:desc, prix=:prix, prixSolde=:solde, qteStock=:qte, seuilQte=:seuil, provenance=:prov WHERE idDeclinaison=:id");
            $stmt->execute([':libelle' => $libelle, ':desc' => $description, ':prix' => $prix, ':solde' => $prixSolde, ':qte' => $qteStock, ':seuil' => $seuilQte, ':prov' => $provenance, ':id' => $idKit]);
        } else {
            $stmt = $connection->prepare("INSERT INTO DeclinaisonProduit (libelleDeclinaison, idProduit, descDeclinaison, prix, prixSolde, qteStock, seuilQte, qualite, provenance) VALUES (:libelle, 51, :desc, :prix, :solde, :qte, :seuil, 'Mixte', :prov)");
            $stmt->execute([':libelle' => $libelle, ':desc' => $description, ':prix' => $prix, ':solde' => $prixSolde, ':qte' => $qteStock, ':seuil' => $seuilQte, ':prov' => $provenance]);
            $idKit = $connection->lastInsertId();
        }

        if (!empty($_FILES['imageFile']['name'])) {
            if (!traiterImageKit($idKit, $_FILES['imageFile'])) throw new Exception("Erreur image.");
        }

        // Mise à jour de la composition
        $connection->prepare("DELETE FROM CompositionProduit WHERE idCompo = ?")->execute([$idKit]);
        $stmtCompo = $connection->prepare("INSERT INTO CompositionProduit (idCompo, idDeclinaison, quantiteProduit) VALUES (?, ?, ?)");
        foreach ($produits_selectionnes as $pId) {
            $stmtCompo->execute([$idKit, $pId, (int)($quantites[$pId] ?? 1)]);
        }
        
        //Mise à jour des fiches techniques
        $detailsFiche = [];
        foreach ($produits_selectionnes as $pId) {
            $stmtNom = $connection->prepare("SELECT libelleDeclinaison FROM DeclinaisonProduit WHERE idDeclinaison = ?");
            $stmtNom->execute([$pId]);
            $detailsFiche[] = (int)($quantites[$pId] ?? 1) . "x " . $stmtNom->fetchColumn();
        }
        $ficheGeneree = "Contient : " . implode(', ', $detailsFiche);
        $connection->prepare("UPDATE DeclinaisonProduit SET ficheTechnique = ? WHERE idDeclinaison = ?")->execute([$ficheGeneree, $idKit]);

        //Validation
        $connection->commit();
        header("Location: crudKit.php?msgSucces=" . urlencode("Le kit a été forgé avec ses objets !"));
        exit;
    } catch (Exception $e) {
        if ($connection->inTransaction()) $connection->rollBack();
        header("Location: crudKit.php?msgErreur=" . "Une erreur inattendue est survenue.");
        exit;
    }
}

// --- RÉCUPÉRATION DES DONNÉES ---
$kits = [];
$produits = [];
try {
    
    $rawKits = $connection->query("SELECT idDeclinaison as id, libelleDeclinaison as libelle, descDeclinaison, prix, prixSolde, qteStock, seuilQte, provenance FROM DeclinaisonProduit WHERE idProduit = 51 ORDER BY idDeclinaison DESC")->fetchAll(PDO::FETCH_ASSOC);

    foreach ($rawKits as $rk) {
        // Image
        $stmtImg = $connection->prepare("SELECT url FROM PhotoProduit WHERE idDeclinaison = ? LIMIT 1");
        $stmtImg->execute([$rk['id']]);
        $rk['image'] = $stmtImg->fetchColumn();

        // Composition
        $stmtCompo = $connection->prepare("SELECT idDeclinaison, quantiteProduit FROM CompositionProduit WHERE idCompo = ?");
        $stmtCompo->execute([$rk['id']]);
        $rk['compo_reelle'] = $stmtCompo->fetchAll(PDO::FETCH_KEY_PAIR);

        $kits[$rk['id']] = $rk;
    }

    $produits = $connection->query("SELECT idDeclinaison AS id, libelleDeclinaison AS libelle FROM DeclinaisonProduit WHERE idProduit <> 51 ORDER BY libelleDeclinaison ASC")->fetchAll(PDO::FETCH_ASSOC);
    
} catch (PDOException $e) {
    $erreurFatale = "Erreur lors de la lecture du grimoire : " . " Une erreur inattendue est survenue.";
}
?>

<!doctype html>
<html lang="fr" class="h-full">
<?php include_once '../includes/head.php' ?>

<style>
    .bg-parchemin-admin {
        background-color: #F5F5DC;
    }

    .modal-magique {
        background: #FAF9F0;
        border: 2px solid #ca8a04;
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.6);
    }

    .input-forge {
        width: 100%;
        background: #fffbef;
        border: 1px solid #b45309;
        padding: 8px;
        border-radius: 4px;
    }

    .checkbox-list {
        max-height: 180px;
        overflow-y: auto;
        border: 1px solid #b45309;
    }

    .custom-scrollbar::-webkit-scrollbar {
        width: 8px;
    }

    .custom-scrollbar::-webkit-scrollbar-thumb {
        background-color: #ca8a04;
        border-radius: 4px;
    }
</style>

<body class="font-body bg-parchemin-admin h-full flex overflow-hidden">

    <?php include '../includes/navAdmin.php'; ?>

    <main class="flex-1 flex flex-col h-full overflow-hidden">
        <header class="h-16 bg-[#F5F5DC] border-b border-yellow-600/30 flex items-center justify-between px-8">
            <h2 class="text-2xl font-bold text-green-900 font-serif">Forge des Kits</h2>
            <button onclick="openModal()" class="bg-[#1A4D2E] text-yellow-400 px-4 py-2 rounded border border-yellow-500 hover:bg-green-800 transition shadow-md font-bold">Assembler un Kit</button>
        </header>

        <div class="flex-1 overflow-y-auto p-8">
            <?php if (isset($erreurFatale)) : ?>
                <div class="bg-orange-100 border-l-4 border-orange-500 p-4 mb-6 text-orange-700 shadow"><?= $erreurFatale ?></div>
            <?php endif; ?>
            <?php if (isset($_GET['msgErreur'])) : ?>
                <div class="bg-red-50 border border-red-400 text-red-800 text-center rounded-xl p-4 mb-6 shadow"><?= htmlspecialchars($_GET['msgErreur']) ?></div>
            <?php elseif (isset($_GET['msgSucces'])) : ?>
                <div class="bg-green-50 border border-green-400 text-green-800 text-center rounded-xl p-4 mb-6 shadow"><?= htmlspecialchars($_GET['msgSucces']) ?></div>
            <?php endif; ?>

            <div class="bg-[#FAF9F0] border border-yellow-600/30 rounded-xl shadow-lg overflow-hidden">
                <table class="min-w-full divide-y divide-yellow-600/20">
                    <thead class="bg-[#1A4D2E]">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs text-yellow-400 uppercase font-bold tracking-wider">Aperçu</th>
                            <th class="px-6 py-3 text-left text-xs text-yellow-400 uppercase font-bold tracking-wider">ID / Nom</th>
                            <th class="px-6 py-3 text-left text-xs text-yellow-400 uppercase font-bold tracking-wider">Prix</th>
                            <th class="px-6 py-3 text-left text-xs text-yellow-400 uppercase font-bold tracking-wider">Stock</th>
                            <th class="px-6 py-3 text-right text-xs text-yellow-400 uppercase font-bold tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-yellow-600/20">
                        <?php foreach ($kits as $k): ?>
                            <tr class="hover:bg-yellow-50/50 transition">
                                <td class="px-6 py-4"><img src="<?= !empty($k['image']) ? '../' . htmlspecialchars($k['image']) : '' ?>"
                                        alt="Aucune image"
                                        class="w-12 h-12 object-cover rounded border border-yellow-600 shadow-sm">
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-2 mb-1">
                                        <span class="text-[10px] text-gray-400 font-mono">#<?= $k['id'] ?></span>
                                        <?php if ($k['prixSolde']): ?>
                                            <span class="bg-red-600 text-white text-[9px] px-1.5 py-0.5 rounded font-bold uppercase tracking-tighter">Promo</span>
                                        <?php endif; ?>
                                    </div>
                                    <span class="font-bold text-green-900"><?= htmlspecialchars($k['libelle']) ?></span>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="font-bold <?= $k['prixSolde'] ? 'line-through text-gray-400 text-sm' : 'text-green-800' ?>"><?= number_format($k['prix'], 2) ?>€</span>
                                    <?php if ($k['prixSolde']): ?>
                                        <br><span class="text-red-600 font-bold"><?= number_format($k['prixSolde'], 2) ?>€</span>
                                    <?php endif; ?>
                                </td>
                                <td class="px-6 py-4">
                                    <?php $alerte = ($k['qteStock'] <= $k['seuilQte']); ?>
                                    <span class="font-bold <?= $alerte ? 'text-red-600' : 'text-green-700' ?>">
                                        <?= $k['qteStock'] ?> unités <?= $alerte ? '⚠️' : '' ?>
                                    </span>
                                    <div class="text-[10px] text-gray-500 italic">Seuil alerte : <?= $k['seuilQte'] ?></div>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <button class="btn-edit bg-indigo-100 text-indigo-700 px-4 py-1.5 rounded hover:bg-indigo-200 font-bold transition" data-kit='<?= htmlspecialchars(json_encode($k), ENT_QUOTES, 'UTF-8') ?>'>Modifier</button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <div id="kitModal" class="hidden fixed inset-0 items-center justify-center bg-black/60 z-50 p-4 backdrop-blur-sm">
        <div class="modal-magique p-6 w-full max-w-2xl rounded-lg relative overflow-y-auto max-h-[95vh]">
            <h3 id="modalTitle" class="text-xl font-bold mb-4 text-green-900 border-b-2 border-yellow-600 pb-2 italic uppercase tracking-wide">Assembler un Kit</h3>
            <form id="kitForm" method="post" enctype="multipart/form-data">
                <input type="hidden" name="idKit" id="inputId">

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div><label class="block font-bold text-sm text-green-900">Nom du Kit</label><input type="text" name="libelle" id="inputLibelle" class="input-forge" required></div>
                    <div><label class="block font-bold text-sm text-green-900">Provenance</label><input type="text" name="provenance" id="inputProvenance" class="input-forge"></div>
                </div>

                <div class="mb-4"><label class="block font-bold text-sm text-green-900">Description</label><textarea name="description" id="inputDesc" class="input-forge h-20" placeholder="Décrivez les pouvoirs de ce kit..."></textarea></div>

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div><label class="block font-bold text-sm text-green-800 font-serif">Prix de base (€)</label><input type="number" step="0.01" name="prix" id="inputPrix" class="input-forge font-bold" required></div>
                    <div><label class="block font-bold text-sm text-red-600 font-serif">Prix Soldé (€)</label><input type="number" step="0.01" name="prixSolde" id="inputPrixSolde" class="input-forge text-red-700 font-bold" placeholder="Optionnel"></div>
                </div>

                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div><label class="block font-bold text-sm text-green-900">Stock actuel</label><input type="number" name="qteStock" id="inputQte" class="input-forge" required></div>
                    <div><label class="block font-bold text-sm text-orange-600 italic">Seuil d'alerte restock</label><input type="number" name="seuilQte" id="inputSeuil" class="input-forge" required value="5"></div>
                </div>

                <div class="mb-4"><label class="block font-bold text-sm text-green-900">Image du Kit</label><input type="file" name="imageFile" class="input-forge" accept="image/*"></div>

                <div class="mb-6">
                    <label class="block font-bold text-sm mb-2 text-green-800 border-l-4 border-green-800 pl-2">Composition du Pack (Au moins 1 objet requis)</label>
                    <div class="checkbox-list p-2 shadow-inner">
                        <?php foreach ($produits as $p): ?>
                            <div class="flex items-center justify-between p-1 border-b border-yellow-100 hover:bg-yellow-50">
                                <label class="flex items-center text-sm cursor-pointer select-none py-1 flex-1">
                                    <input type="checkbox" name="produits[]" value="<?= $p['id'] ?>" class="mr-3 checkbox-prod w-4 h-4 accent-green-700">
                                    <span class="text-green-900"><?= htmlspecialchars($p['libelle']) ?></span>
                                </label>
                                <div class="flex items-center gap-1 hidden qte-wrapper">
                                    <span class="text-[10px] text-gray-500">x</span>
                                    <input type="number" name="quantites[<?= $p['id'] ?>]" value="1" min="1" class="w-12 text-center border-2 border-green-200 rounded p-0.5 qte-input font-bold text-green-800">
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <div class="flex justify-end gap-3 pt-4 border-t-2 border-yellow-600/30">
                    <button type="button" onclick="closeModal()" class="px-6 py-2 bg-gray-200 rounded hover:bg-gray-300 transition font-bold text-gray-700 uppercase text-xs tracking-widest">Annuler</button>
                    <button type="submit" name="action_kit" class="px-6 py-2 bg-green-700 text-yellow-400 rounded font-bold hover:bg-green-800 shadow-md transition uppercase text-xs tracking-widest border border-yellow-500">Valider la forge</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Gestion de l'affichage de la quantité seulement si coché
        document.querySelectorAll('.checkbox-prod').forEach(cb => {
            cb.addEventListener('change', function() {
                const wrapper = this.closest('div').querySelector('.qte-wrapper');
                if (wrapper) wrapper.classList.toggle('hidden', !this.checked);
            });
        });

        // Sécurité JavaScript avant envoi
        document.getElementById('kitForm').addEventListener('submit', function(e) {
            const checkedObjects = document.querySelectorAll('.checkbox-prod:checked');
            if (checkedObjects.length === 0) {
                e.preventDefault(); // Empêche l'envoi
                alert("Merlin ! Vous ne pouvez pas créer un kit sans objets ! Sélectionnez au moins un ingrédient.");
            }
        });

        function openModal() {
            document.getElementById('kitForm').reset();
            document.getElementById('inputId').value = "";
            document.getElementById('modalTitle').innerText = "Assembler un nouveau Kit";
            document.querySelectorAll('.checkbox-prod').forEach(cb => {
                cb.checked = false;
                cb.closest('div').querySelector('.qte-wrapper').classList.add('hidden');
            });
            document.getElementById('kitModal').classList.replace('hidden', 'flex');
        }

        document.querySelectorAll('.btn-edit').forEach(btn => {
            btn.addEventListener('click', function() {
                const d = JSON.parse(this.getAttribute('data-kit'));
                openModal();
                document.getElementById('modalTitle').innerText = "Modifier la forge : " + d.libelle;
                document.getElementById('inputId').value = d.id;
                document.getElementById('inputLibelle').value = d.libelle;
                document.getElementById('inputDesc').value = d.descDeclinaison || "";
                document.getElementById('inputPrix').value = d.prix;
                document.getElementById('inputPrixSolde').value = d.prixSolde || "";
                document.getElementById('inputQte').value = d.qteStock;
                document.getElementById('inputSeuil').value = d.seuilQte || "5";
                document.getElementById('inputProvenance').value = d.provenance;

                if (d.compo_reelle) {
                    Object.entries(d.compo_reelle).forEach(([id, qte]) => {
                        const cb = document.querySelector(`.checkbox-prod[value="${id}"]`);
                        if (cb) {
                            cb.checked = true;
                            const wrapper = cb.closest('div').querySelector('.qte-wrapper');
                            const qIn = cb.closest('div').querySelector('.qte-input');
                            qIn.value = qte;
                            wrapper.classList.remove('hidden');
                        }
                    });
                }
            });
        });

        function closeModal() {
            document.getElementById('kitModal').classList.replace('flex', 'hidden');
        }
    </script>
</body>

</html>
