#!/bin/bash

# エラー発生時に即終了させる
set -ex

chown -R www-data:www-data /var/www/html

# MariaDBコンテナが起動完了するまで待機させる
echo "[+] Waiting for MariaDB..."
while ! mysqladmin ping -h "$WORDPRESS_DB_HOST" --silent; do
    sleep 2
done

# wp-config.phpがまだ存在しない場合のみ初期設定を行う
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "[+] Starting WordPress setup..."
    # WordPress作業ディレクトリに移動
    cd /var/www/html
    
    # WordPressをダウンロード
    echo "[+] Downloading WordPress..."
    wp core download --path=/var/www/html --locale=ja --allow-root
    
    # wp-config.phpを環境変数に基づいて自動生成する
    echo "[+] Creating wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root \
        --skip-check || { echo "[!] Config creation failed"; exit 1; }

    # サイト情報と管理者ユーザーを自動設定する
    echo "[+] Installing WordPress core..."
    wp core install \
        --url="$DOMAIN" \
        --title="$WORDPRESS_SITE_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        --allow-root || { echo "[!] Core install failed"; exit 1; }

    # 編集者ロールの一般ユーザーを追加する
    echo "[+] Creating editor user..."
    wp user create \
        "${WORDPRESS_EDITOR_USER}" \
        "${WORDPRESS_EDITOR_EMAIL}" \
        --user_pass="${WORDPRESS_EDITOR_PASSWORD}" \
        --role=editor \
        --allow-root || { echo "[!] Editor user creation failed"; exit 1; }

    # ここで一応所有権をwww-dataに再設定しておく(NginxやPHP-FPMの実行ユーザーのため)
    echo "[+] Setup complete. Fixing permissions..."
    chown -R www-data:www-data /var/www/html
fi

# WordPressのセットアップ＆ユーザー作成
# MariaDB が起動するまで待つ ※コンテナではなく、DBの準備が整うまで待つ
# WordPress の設定ファイルがない場合（初回起動時）のみ、以下を実行
# WordPress をインストールする
# WordPress の設定ファイル（DBとの接続設定など）を作成
# WordPress の初期設定を行い、管理者ユーザーを作成
# 一般ユーザー（投稿者）を作成
# PHP-FPM を起動する

# PHP-FPMを実行する(フォアグラウンド)
echo "[+] Starting PHP-FPM..."
exec php-fpm7.4 -F