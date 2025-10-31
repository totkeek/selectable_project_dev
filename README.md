# Docker PHP + MySQL環境

このプロジェクトは、DockerでPHPとMySQLの開発環境を構築します。

## 構成

- **PHP 8.1** with Apache
- **MySQL 8.0**
- **phpMyAdmin**

## セットアップ

1. リポジトリをクローン
```bash
git clone <repository-url>
cd docker_test_dev2
```

2. 環境変数ファイルをコピー
```bash
cp .env.example .env
```

3. 必要に応じて.envファイルを編集

4. 環境を起動
```bash
docker-compose up -d
```

## アクセス

- アプリケーション: http://localhost:8080
- phpMyAdmin: http://localhost:8081

## 停止方法

```bash
docker-compose down
```

## データベース接続情報

- ホスト: localhost (外部から) / db (コンテナ内から)
- ポート: 3306
- データベース名: testdb / emptydb
- ユーザー: testuser
- パスワード: testpassword（本番環境では必ず変更）

## ディレクトリ構成

```
docker_test_dev2/
├── docker-compose.yml      # Docker Compose設定
├── Dockerfile             # PHP環境のDockerfile
├── .env.example          # 環境変数テンプレート
├── .gitignore           # Git除外ファイル
├── README.md            # このファイル
├── src/                 # PHPソースコード
│   ├── index.php       # メインページ
│   ├── empty_db.php    # 空DBテスト
│   └── info.php        # PHP情報
├── database/           # データベース管理
│   └── schema/         # スキーマ定義
│       ├── testdb_schema.sql
│       └── emptydb_schema.sql
└── mysql-init/         # MySQL初期化スクリプト
    └── init.sql        # 初期データ作成
```

## データベーススキーマ管理

- `database/schema/` ディレクトリにテーブル定義を管理
- 新しいテーブルを追加する場合は、対応するスキーマファイルを更新
- マイグレーション的な変更履歴が必要な場合は、番号付きファイルを作成

## 開発ワークフロー

1. スキーマ変更時は `database/schema/` を更新
2. 必要に応じて `mysql-init/init.sql` も更新
3. 大きな変更の場合は `docker-compose down -v && docker-compose up -d` でリセット

## トラブルシューティング

- ポート8080, 8081, 3306が使用中の場合は、docker-compose.ymlのポート設定を変更
- データベース接続エラーの場合は、.envファイルの設定を確認
- 完全リセットが必要な場合: `docker-compose down -v && docker-compose up -d`