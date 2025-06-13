# WordPressのセットアップ＆ユーザー作成
# MariaDB が起動するまで待つ ※コンテナではなく、DBの準備が整うまで待つ

# WordPress の設定ファイルがない場合（初回起動時）のみ、以下を実行
# WordPress をインストールする
# WordPress の設定ファイル（DBとの接続設定など）を作成
# WordPress の初期設定を行い、管理者ユーザーを作成
# 一般ユーザー（投稿者）を作成
# PHP-FPM を起動する

#!/bin/bash
set -ex

# WordPressの初期設定
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPressの初期設定を行います。"
    # WordPressをダウンロード
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
    rm /tmp/wordpress.tar.gz

    # WordPressの設定ファイルを作成
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    # DB接続設定を更新
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php

    # セキュリティキーを生成して設定ファイルに追加
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php

    # ディレクトリの権限を設定
    chown -R www-data:www-data /var/www/html
else
    echo "WordPressはすでに初期化されています。"
fi


# PHP-FPMの設定ファイルを更新
echo "PHP-FPMの設定ファイルを更新します。"
cat <<EOF > /etc/php/7.4/fpm/pool.d/www.conf
[www]
user = www-data
group = www-data
listen = /var/run/php/php7.4-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.max_requests = 500
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
php_admin_flag[log_errors] = on
php_value[session.save_path] = /var/lib/php/sessions
php_value[upload_tmp_dir] = /var/lib/php/uploads
php_value[date.timezone] = UTC
php_value[display_errors] = Off
php_value[display_startup_errors] = Off
php_value[log_errors] = On
php_value[error_reporting] = E_ALL & ~E_DEPRECATED & ~E_STRICT
php_value[session.cookie_httponly] = 1
php_value[session.cookie_secure] = 1
php_value[session.use_strict_mode] = 1
php_value[session.use_only_cookies] = 1
php_value[session.cookie_samesite] = Strict
php_value[session.gc_maxlifetime] = 1440
php_value[session.save_handler] = files
php_value[session.serialize_handler] = php
php_admin_value[upload_max_filesize] = 64M
php_admin_value[post_max_size] = 64M            