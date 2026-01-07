<?php
$user = 'R2025MYSAE3005';
$password = 'j4X3F9Sn2bsqL7!';

try {
    $connection = new PDO(
        'mysql:host=localhost;dbname=R2025MYSAE3005;charset=UTF8',
        $user,
        $password
    );
     // Activer le mode exception
    $connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Erreur : " . $e->getMessage() . "<br>";
    die();
}
?>
