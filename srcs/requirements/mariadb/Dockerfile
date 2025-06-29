# # DockerイメージのベースになるOSを指定する
# # MariaDB（データベース本体）をインストールする
# # 設定ファイルを MariaDBの設定フォルダにコピーする
# # DBを初期化するためのスクリプトをコンテナ内にコピーする
# # MariaDBコンテナが起動時に、スクリプトを実行 する

# ベースイメージ、バージョン設定
FROM debian:bullseye

# パッケージ情報更新、MariaDBインストール
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*
# /var/run/mysqld is a directory that is used by MariaDB to store the socket file
# which allows clients(local processes) to connect to the database server.
RUN mkdir -p /var/run/mysqld
# ensure that the directory is owned by the mysql user and group
RUN chown -R mysql:mysql /var/run/mysqld

# MariaDB用設定ファイルと初期化スクリプトコピー
# /etc/mysql/my.cnf is the main configuration file for MariaDB
# which contains settings for the database server.
# /docker-entrypoint-initdb.d/init.sh is a script that will be executed when the container starts.
# It is used to initialize the database, create users, and set up the initial database structure.
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./tools/init.sh /docker-entrypoint-initdb.d/init.sh
# init.shに実行権限を付与する
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

# スクリプト実行
ENTRYPOINT ["/docker-entrypoint-initdb.d/init.sh"]
