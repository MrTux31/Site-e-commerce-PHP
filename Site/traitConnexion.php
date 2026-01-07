<?php
session_start();
require_once 'connec.inc.php';


/**
 * Tente de trouver un utilisateur (Client ou Admin) par email et vérifie le mot de passe
 * Retourne un tableau avec le type d'utilisateur et ses données, ou false
 */
function authentifierUtilisateur($email, $pwd, $db) {
    // 1. Chercher dans la table Administrateur (Attention : la colonne est 'mdp')
    // On utilise "AS motDePasse" pour que le reste du code PHP reste identique
    $stmt = $db->prepare("SELECT idAdmin as id, nomAdmin as nom, prenomAdmin as prenom, mdp as motDePasse, 'admin' as type FROM Administrateur WHERE email = :email LIMIT 1");
    $stmt->execute([':email' => $email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // 2. Si non trouvé chez l'admin, chercher dans Client (Ici c'est bien 'motDePasse')
    if (!$user) {
        $stmt = $db->prepare("SELECT idClient as id, nom, prenom, motDePasse, 'client' as type FROM Client WHERE email = :email LIMIT 1");
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // 3. Vérification du mot de passe
    if ($user && password_verify($pwd, $user['motDePasse'])) {
        return $user;
    }

    return false;
}

// --- Traitement du formulaire ---

if (!isset($_POST['login'], $_POST['login-password'])) {
    header("Location: connexion.php?msgErreur=" . urlencode("Formulaire incomplet"));
    exit;
}

$email = $_POST['login'];
$pwd   = $_POST['login-password'];

$userData = authentifierUtilisateur($email, $pwd, $connection);

if ($userData) {
    // Authentification réussie
    $_SESSION["SLeRoiMerlin"] = "OK";
    
    // On remplit les sessions selon le type
    if ($userData['type'] === 'client') {
        $_SESSION["idClient"] = $userData['id']; 
        $_SESSION["nomClient"] = $userData['nom'];
        $_SESSION["prenomClient"] = $userData['prenom'];
        $_SESSION["role"] = "client";
    } else {
        $_SESSION["idAdmin"] = $userData['id']; 
        $_SESSION["nomAdmin"] = $userData['nom'];
        $_SESSION["prenomAdmin"] = $userData['prenom'];
        $_SESSION["role"] = "admin";
    }
    // --- GESTION DU REMEMBER-ME ---
    $rememberMe = isset($_POST['remember-me']);
    if ($rememberMe) {
        try {
            $selector = bin2hex(random_bytes(12));
            $validator = bin2hex(random_bytes(32));
            $hashed_validator = hash('sha256', $validator);
            
            $duree_jours = 30;
            $expiry = date('Y-m-d H:i:s', time() + (86400 * $duree_jours));
            
            // On enregistre le token avec l'ID et le type (client ou admin)
            $stmtToken = $connection->prepare("INSERT INTO auth_tokens (selector, token, user_id, user_type, expires_at) VALUES (?, ?, ?, ?, ?)");
            $stmtToken->execute([$selector, $hashed_validator, $userData['id'], $userData['type'], $expiry]);
            
            $isSecure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off');

            $options = [
                'expires'  => time() + (86400 * 30),
                'path'     => '/',
                'domain'   => '', 
                'secure'   => $isSecure,
                'httponly' => true,
                'samesite' => 'Lax'
            ];

            // On tente l'envoi
            $cookieSent = setcookie("CLeRoiMerlin", $selector . ':' . $validator, $options);
        } catch (PDOException $e) {
            error_log("Erreur lors de la gestion du cookie : " . $e->getMessage());
        }
    }

    // Redirection (on peut rediriger vers l'admin si c'est un admin)
    if ($userData['type'] === 'admin') {
        header("Location: index.php"); // Ou index.php selon vos besoins
    } else {
        header("Location: index.php");
    }
    exit;

} else {
    // Échec de l'authentification
    header("Location: connexion.php?msgErreur=" . urlencode("Identifiants incorrects ou compte inexistant"));
    exit;
}
?>