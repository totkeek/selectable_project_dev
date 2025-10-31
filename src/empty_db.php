<?php
echo "<h1>空のデータベース (emptydb) 接続テスト</h1>";
echo "<p>現在の時刻: " . date('Y-m-d H:i:s') . "</p>";

try {
    $host = $_ENV['DB_HOST'] ?? 'db';
    $dbname = $_ENV['EMPTY_DB_NAME'] ?? 'emptydb';
    $username = $_ENV['DB_USER'] ?? 'testuser';
    $password = $_ENV['DB_PASSWORD'] ?? 'testpassword';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "<p style='color: green;'>✅ 空のデータベース '{$dbname}' 接続成功！</p>";
    
    // データベース内のテーブル一覧を取得
    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    echo "<h2>テーブル一覧</h2>";
    if (empty($tables)) {
        echo "<p style='color: blue;'>📄 このデータベースにはテーブルがありません（空のデータベースです）</p>";
    } else {
        echo "<ul>";
        foreach ($tables as $table) {
            echo "<li>" . htmlspecialchars($table) . "</li>";
        }
        echo "</ul>";
    }
    
    echo "<h2>新しいテーブルを作成する例</h2>";
    echo "<p>以下のSQLでテーブルを作成できます：</p>";
    echo "<pre style='background-color: #f5f5f5; padding: 10px; border-radius: 5px;'>";
    echo "CREATE TABLE example_table (\n";
    echo "    id INT AUTO_INCREMENT PRIMARY KEY,\n";
    echo "    name VARCHAR(100) NOT NULL,\n";
    echo "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n";
    echo ");";
    echo "</pre>";
    
} catch (PDOException $e) {
    echo "<p style='color: red;'>❌ データベース接続エラー: " . $e->getMessage() . "</p>";
}

echo "<hr>";
echo "<h2>リンク</h2>";
echo "<ul>";
echo "<li><a href='index.php'>メインページ（testdb）</a></li>";
echo "<li><a href='http://localhost:8081' target='_blank'>phpMyAdmin</a></li>";
echo "</ul>";
?>