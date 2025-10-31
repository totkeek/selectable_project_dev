-- 初期化スクリプト
-- このファイルはコンテナ起動時に自動実行されます

-- データベースの文字セット設定
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 空のデータベースを作成
CREATE DATABASE IF NOT EXISTS emptydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- testdbを明示的に作成（既に存在する場合はスキップ）
CREATE DATABASE IF NOT EXISTS testdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ユーザーに両方のデータベースへのアクセス権限を付与
GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';
GRANT ALL PRIVILEGES ON emptydb.* TO 'testuser'@'%';
FLUSH PRIVILEGES;

-- testdbにサンプルテーブルの作成
USE testdb;

CREATE TABLE IF NOT EXISTS sample_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- サンプルデータの挿入
INSERT INTO sample_data (title, description, status) VALUES
('サンプル1', 'これは最初のサンプルデータです。', 'active'),
('サンプル2', 'これは2番目のサンプルデータです。', 'active'),
('サンプル3', 'これは3番目のサンプルデータです。', 'inactive');