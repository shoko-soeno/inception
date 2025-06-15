#!/bin/bash

# エラー発生時に即終了させる
set -e

# SQLファイルを動的生成(PHPで記述するとENVを使用できないため)
cat << EOF > /docker-entrypoint-initdb.d/init.sql

SELECT 'Initializing database...' AS message;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;

SELECT 'Database initialized.' AS message;

EOF

# WordPress用のデータベースを作成
# 初回起動時に必要なSQLファイルを作る

# DBの初期設定（データベースとユーザーを作成、権限を設定）
# 設定ファイルに以下を書き込む
# 「もし指定のDBがなければ新しく作る」
# 「もし指定のユーザーがなければ作り、パスワードを設定する」
# 「作成されたユーザーに指定のDBへの全ての権限を与える」
# 「ユーザーの権限情報を更新する」
# MariaDBを起動して、設定ファイルの内容で初期化する

# 生成したSQLを使って初期化しながらMariaDBを起動させる
exec mariadbd --init-file=/docker-entrypoint-initdb.d/init.sql
