  <?php


    require_once("./connec.inc.php");
    // Si le fichier est exécuté directement (en tapant le nom du fichier dans l'url)
    if (basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
        header("Location: catalogue.php"); //On redirige vers le catalogue
        exit;
    }

    //On récup tous les params de la requete
    $quality       = $_GET['quality'] ?? null; //Si isset quality alors on le récup, sinon on met null
    $regroupement  = $_GET['regroupement'] ?? null;
    $category      = $_GET['category'] ?? null;
    $subCategory   = $_GET['sub-category'] ?? null;
    $sort          = $_GET['sort'] ?? null;
    $search        = $_GET['search'] ?? '';



    //On charge tous les éléments nécessaires
    $qualites = chargerQualites();
    $regroupements = chargerRegroupements();
    $categories = chargerCategories();
    $produits = effectuerTriProduits( //On effectue le tri des produits à afficher
        $quality,
        $regroupement,
        $category,
        $subCategory,
        $sort,
        $search
    );


    /**
     * Fonction permettant de charger les différentes qualités disponibles
     */

    function chargerQualites()
    {

        $tab_qualites = [];
        try {
            global $connection;
            $statement = $connection->prepare("SELECT DISTINCT qualite FROM DeclinaisonProduit"); //Récup toutes les qualites
            $statement->execute(); //Executer la commande

            while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
                $tab_qualites[] = $ligne['qualite'];
            }
        } catch (PDOException $e) {
            error_log("Erreur SQL chargerQualites : " . $e->getMessage());
        }

        if (empty($tab_qualites)) { //Si aucune qualité n'est trouvée
            $tab_qualites[] = 'Aucune qualité trouvée';
        }


        return $tab_qualites; //On renvoie le tableau de qualités

    }

    /**
     * Fonction permettant de charger les différentes regroupements disponibles
     */

    function chargerRegroupements()
    {
        $tab_regroupements = [];

        try {
            global $connection;
            $statement = $connection->prepare("SELECT * FROM Regroupement"); //Récup tous les regroupements
            $statement->execute(); //Executer la commande

            while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
                $tab_regroupements[$ligne['idRegroupement']] = $ligne['libelle']; //On enregistre idRegroupement =>libelle pour chaque regroupement
            }
        } catch (PDOException $e) {
            error_log("Erreur SQL chargerRegroupements : " . $e->getMessage());
        }

        if (empty($tab_regroupements)) { //Si aucun regroupement n'est trouvé
            $tab_regroupements[] = 'Aucun regroupement trouvé';
        }

        return $tab_regroupements; //On renvoie le tableau de regroupements

    }

    /**
     * Fonction permettant de charger les différentes catégories disponibles
     */

    function chargerCategories()
    {
        $tab_categories = [];


        try {
            global $connection;
            $statement = $connection->prepare("SELECT * FROM Categorie WHERE Categorie.idCategorieParent IS NULL");
            $statement->execute(); //Executer la commande
            while ($ligne  = $statement->fetch((PDO::FETCH_ASSOC))) { //Récup un tableau associatif
                $tab_categories[$ligne['idCategorie']] = $ligne['libelle']; //On enregistre idCategorie -> libelle pour chaque catégorie
            }
        } catch (PDOException $e) {
            error_log("Erreur SQL chargerCategories : " . $e->getMessage());
        }

        if (empty($tab_categories)) { //Si aucune catégorie n'est trouvée
            $tab_categories[] = 'Aucune catégorie trouvée';
        }

        return $tab_categories; //On renvoie le tableau de catégories
    }

    /**
     * Fonction permettant de charger les différentes catégories enfants dispos pour une catégorie parent
     */

    function chargerCategoriesEnfants($idCategorieParent)
    {
        $tab_categories = [];
        try {
            global $connection;
            $statement = $connection->prepare("CALL getCategEnfants(:idCategorieParent)");
            $statement->bindParam(':idCategorieParent', $idCategorieParent, PDO::PARAM_INT);
            $statement->execute();

            while ($ligne = $statement->fetch(PDO::FETCH_ASSOC)) {
                $tab_categories[$ligne['idCategorie']] = $ligne['libelle'];
            }

            // Important : libérer le curseur si la procédure retourne plusieurs résultats
            $statement->closeCursor();
        } catch (PDOException $e) {
            error_log("Erreur SQL chargerCategoriesEnfants : " . $e->getMessage());
        }



        return $tab_categories;
    }



    /**
     * Permet de faire une requete en bd pour charger les produits selon les filtres appliqués
     * Retourne un statement à parcourir
     */
    function chargerProduits($quality = null, $regroupement = null, $category = null, $subCategory = null, $sort = null, $search = null)
    {
        global $connection;

        $sql = "SELECT DISTINCT d.*, c.libelle as categorie_libelle, p.libelle as produit_libelle
            FROM DeclinaisonProduit d
            LEFT JOIN Regrouper re ON re.idProduit = d.idProduit
            LEFT JOIN Regroupement r ON re.idRegroupement = r.idRegroupement
            LEFT JOIN Appartenir a ON a.idProduit = d.idProduit
            LEFT JOIN Produit p ON p.idProduit = d.idProduit
            LEFT JOIN Categorie c ON c.idCategorie = a.idCategorie
            WHERE 1=1"; //technique 1=1 : permet de placer les AND ... plus facilement à la suite pas besoin de savoir qui est le premier

        $params = [];

        // Filtre qualité
        if ($quality && $quality != 'all') {
            $sql .= " AND d.qualite = :quality";
            $params[':quality'] = $quality;
        }

        // Filtre regroupement
        if ($regroupement && $regroupement != 'all') {
            $sql .= " AND re.idRegroupement = :regroupement";
            $params[':regroupement'] = $regroupement;
        }
        if ($search) {
            $mots = explode(' ', $search); // Sépare la recherche par mots
            // Exemple : si $search = "potion mana"
            // $mots = ['potion', 'mana']

            foreach ($mots as $i => $mot) { //On va comparé le mot de la recherche à différents éléments
                $sql .= " AND (
            d.libelleDeclinaison LIKE :mot$i 
            OR p.libelle LIKE :mot$i
            OR c.libelle LIKE :mot$i
            OR r.libelle LIKE :mot$i
        )";


                $params[":mot$i"] = "%$mot%";
                // Exemple après la première itération ($i=0, $mot='potion'):
                // $params = [':mot0' => '%potion%']
                // Exemple après la deuxième itération ($i=1, $mot='mana'):
                // $params = [':mot0' => '%potion%', ':mot1' => '%mana%']
            }
        }

        // Filtre catégorie / sous-catégorie
        if ($category && $category != 'all') { //Si la catégorie est renseignée ('' renvoie false / si la catégorie n'est pas all)
            //on prend soit l'id de la sous catégorie (si sélectionnée) soit l'id de la catégorie parent
            $idFiltre = ($subCategory && $subCategory != 'all') ? $subCategory : $category;

            $produits_categ = getProduitsByCategorie($idFiltre); //On récup les ids de tous les produits de cette catégorie
            //Si il y a des produits récupérés
            $placeholders = [];
            foreach ($produits_categ as $i => $idProduit) {
                $placeholder = ":prod$i"; //On crée un param nommé pour chaque produit
                $placeholders[] = $placeholder;  //Ex : $placeholders = [":prod0", ":prod1", ":prod2"]
                //Sauvegarde pour le passage de paramètres nommés 
                $params[$placeholder] = $idProduit;
                // On sauvegarde chaque paramètre nommé pour lier l'ID du produit à la requête PDO
                // Exemple : $params = [":prod0" => 101, ":prod1" => 102]
            }
            //Si des produits ont été trouvés dans la catégorie
            if (!empty($placeholders)) {
                //On recherche les idDeclinaisons contenues dans $placeholders = [":prod0", ":prod1", ":prod2"]
                $sql .= " AND d.idDeclinaison IN (" . implode(',', $placeholders) . ")";
            }
            //Si aucun produit n'a été trouvé dans la catégorie
            else {
                // Aucun produit dans cette catégorie, on force un résultat vide
                $sql .= " AND 0"; // ou AND d.idDeclinaison IN (NULL)
            }
        }

        // Tri
        if ($sort) {
            if ($sort === 'price-asc') { //Si le prix croissant est coché
                $sql .= " ORDER BY COALESCE(d.prixSolde, d.prix) ASC"; //Si le prix solde n'est pas null on prends lui pour le tri, sinon on prends prix normal
            }
            if ($sort === 'price-desc') { //Si le prix décroissant est coché
                $sql .= " ORDER BY COALESCE(d.prixSolde, d.prix) DESC";
            }
        }
        $stmt = null; //Initialise stmt
        try {
            $stmt = $connection->prepare($sql);
            $stmt->execute($params);
        } catch (PDOException $e) {
            error_log("Erreur SQL chargerProduits : " . $e->getMessage());
        }

        return $stmt;
    }

    /**
     * Fonction permettant d'effectuer le tri des produits
     * Retourne un tableau de produits triés
     */
    function effectuerTriProduits(
        $quality,
        $regroupement,
        $category,
        $subCategory,
        $sort,
        $search
    ) {

        $statement = chargerProduits(
            $quality,
            $regroupement,
            $category,
            $subCategory,
            $sort,
            $search
        );
        $produits = [];
        if ($statement) { //Si le statement renvoyé n'est pas null
            while ($ligne = $statement->fetch(PDO::FETCH_ASSOC)) {
                $produits[] = $ligne; //On ajoute le produit
            }
        }
        return $produits; //Si tab produits vide retournés alors "Aucun produit trouvé"
    }
    /**
     * Récupère tous les id produit d'une catégorie (ainsi que des sous catégories)
     */
    function getProduitsByCategorie($idCategorie)
    {
        $produits_categ = [];
        try {
            global $connection;
            // Récupérer tous les produits d'une catégorie (y compris enfants)
            $statement = $connection->prepare("CALL getProduitsByCategorie(:idCategorie)");
            $statement->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
            $statement->execute();
            while ($row = $statement->fetch(PDO::FETCH_ASSOC)) {
                $produits_categ[] = $row['idDeclinaison']; // On stocke tous les id produit de cette catégorie
            }
            $statement->closeCursor();
        } catch (PDOException $e) {
            error_log("Erreur SQL getProduitsByCategorie : " . $e->getMessage());
        }

        return $produits_categ;
    }






    ?>