# DockerイメージのベースになるOSを指定する
# 必要なソフトウェアをインストール
# MariaDB（操作用ツール）
# PHP 言語の実行環境、PHP コマンドラインツール、拡張機能など
# WordPress のコマンドラインツール
# WordPressのデータを保存するディレクトリを作る
# PHP の設定ファイル（www.conf）をコピー する
# WordPressを初期化するためのスクリプトをコンテナ内にコピーする
# WordPressコンテナが起動時に、スクリプトを実行 する

# コンテナ起動時にWordPressを初期化するスクリプトを実行
# ENTRYPOINT ["/usr/local/bin/init.sh"]
# ENTRYPOINTはCMDの前に実行されるため、CMDでphp-fpmを起動する
# ENTRYPOINTを使用すると、コンテナ起動時に必ずinit.shが実行される
# ENTRYPOINTを使用しない場合、コンテナ起動時に手動でinit.shを実行する必要がある
# ENTRYPOINTを使用する場合、コンテナ起動時に必ずinit.shが実行されるため、
# コンテナ起動時にWordPressを初期化する必要がある

# ベースイメージ、バージョン設定
FROM debian:bullseye

# PHP,MariaDB client, curlインストール
RUN apt-get update && apt-get install -y php7.4 php7.4-fpm php7.4-cli php7.4-mysql mariadb-client curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 必要な配置先ディレクトリ作成
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# WP-CLIインストール、権限設定
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && chown root:root /usr/local/bin/wp

# PHP-FPM設定を上書きする
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
# COPY ./scripts/wordpress/wp-cli.phar /usr/local/bin/wp
# COPY ./scripts/wordpress/wp-config.php /var/www/html/wp-config.php
# COPY ./scripts/wordpress/www.conf /etc/php/7.4/fpm/pool.d/www.conf
# COPY ./scripts/wordpress/init.sh /usr/local/bin/init.sh

# /run/php がないと PHP-FPM が起動できないため、事前に作成
RUN mkdir -p /run/php
# RUN chmod +x /usr/local/bin/wp && \
#     chmod +x /usr/local/bin/init.sh && \
#     mkdir -p /var/www/html && \
#     chown -R www-data:www-data /var/www/html && \
#     chmod -R 755 /var/www/html  && \
#     /usr/local/bin/init.sh && \
#     rm -rf /var/lib/apt/lists/*
# EXPOSE 9000
# CMD ["php-fpm7.4", "-F"]

# 起動スクリプトを追加する
COPY ./tools/init.sh /docker-entrypoint.d/init.sh
RUN chmod +x /docker-entrypoint.d/init.sh

# スクリプト実行
ENTRYPOINT ["/docker-entrypoint.d/init.sh"]
