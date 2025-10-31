<?php
echo "<h1>PHP + MySQL Docker環境</h1>";
echo "<p>現在の時刻: " . date('Y-m-d H:i:s') . "</p>";

// データベース接続テスト
try {
    $host = $_ENV['DB_HOST'] ?? 'db';
    $dbname = $_ENV['DB_NAME'] ?? 'testdb';
    $username = $_ENV['DB_USER'] ?? 'testuser';
    $password = $_ENV['DB_PASSWORD'] ?? 'testpassword';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "<p style='color: green;'>✅ データベース接続成功！</p>";
    
    // サンプルテーブルの作成とデータ挿入
    $pdo->exec("CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    // サンプルデータの挿入（重複を避けるため）
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM users");
    $stmt->execute();
    $count = $stmt->fetchColumn();
    
    if ($count == 0) {
        $pdo->exec("INSERT INTO users (name, email) VALUES 
            ('田中太郎', 'tanaka@example.com'),
            ('佐藤花子', 'sato@example.com'),
            ('鈴木一郎', 'suzuki@example.com')");
    }
    
    // データの表示
    $stmt = $pdo->query("SELECT * FROM users ORDER BY id");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<h2>ユーザー一覧</h2>";
    echo "<table border='1' style='border-collapse: collapse;'>";
    echo "<tr><th>ID</th><th>名前</th><th>メール</th><th>作成日時</th></tr>";
    
    foreach ($users as $user) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($user['id']) . "</td>";
        echo "<td>" . htmlspecialchars($user['name']) . "</td>";
        echo "<td>" . htmlspecialchars($user['email']) . "</td>";
        echo "<td>" . htmlspecialchars($user['created_at']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
} catch (PDOException $e) {
    echo "<p style='color: red;'>❌ データベース接続エラー: " . $e->getMessage() . "</p>";
}

echo "<hr>";
echo "<h2>PHP情報</h2>";
echo "<p>PHP Version: " . phpversion() . "</p>";
echo "<p>Server: " . $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown' . "</p>";

echo "<hr>";
echo "<h2>リンク</h2>";
echo "<ul>";
echo "<li><a href='empty_db.php'>空のデータベース (emptydb) 接続テスト</a></li>";
echo "<li><a href='http://localhost:8081' target='_blank'>phpMyAdmin (ポート8081)</a></li>";
echo "<li><a href='info.php'>PHP Info</a></li>";
echo "</ul>";
?>