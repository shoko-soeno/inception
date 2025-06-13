# DockerイメージのベースになるOSを指定する
# 必要なソフトウェアをインストール
# MariaDB（操作用ツール）
# PHP 言語の実行環境、PHP コマンドラインツール、拡張機能など
# WordPress のコマンドラインツール
# WordPressのデータを保存するディレクトリを作る
# PHP の設定ファイル（www.conf）をコピー する
# WordPressを初期化するためのスクリプトをコンテナ内にコピーする
# WordPressコンテナが起動時に、スクリプトを実行 する

FROM debian:latest
RUN apt-get update && \
    apt-get install -y mariadb-client php php-cli php-fpm php-mysql php-curl php-xml php-mbstring && \
    rm -rf /var/lib/apt/lists/*
COPY ./scripts/wordpress/wp-cli.phar /usr/local/bin/wp
COPY ./scripts/wordpress/wp-config.php /var/www/html/wp-config.php
COPY ./scripts/wordpress/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./scripts/wordpress/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/wp && \
    chmod +x /usr/local/bin/init.sh && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html  && \
    /usr/local/bin/init.sh && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 9000
CMD ["php-fpm7.4", "-F"]
# コンテナ起動時にWordPressを初期化するスクリプトを実行
# ENTRYPOINT ["/usr/local/bin/init.sh"]
# ENTRYPOINTはCMDの前に実行されるため、CMDでphp-fpmを起動する
# ENTRYPOINTを使用すると、コンテナ起動時に必ずinit.shが実行される
# ENTRYPOINTを使用しない場合、コンテナ起動時に手動でinit.shを実行する必要がある
# ENTRYPOINTを使用する場合、コンテナ起動時に必ずinit.shが実行されるため、
# コンテナ起動時にWordPressを初期化する必要がある