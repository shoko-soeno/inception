# ベースイメージ　軽量なlinuxディストリビューション
FROM alpine:3.18

# 環境変数の設定（.envで上書き可能）
ENV MYSQL_ROOT_PASSWORD=rootpass \
    MYSQL_DATABASE=wordpress \
    MYSQL_USER=wpuser \
    MYSQL_PASSWORD=wppass

# MariaDBと必要なパッケージのインストール
RUN apk update && apk add --no-cache mariadb mariadb-client supervisor

# データディレクトリ（socket）を用意
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld

# MariaDBの設定ファイルをコピー（カスタム設定があれば使うが、なくてもOK）
COPY ./conf/my.cnf /etc/my.cnf

# 自作の起動スクリプト
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

# デフォルトの接続ポート3306を公開
EXPOSE 3306

# コンテナ起動時に実行される
# MariaDBを起動するスクリプトをENTRYPOINTに指定　
ENTRYPOINT ["/init.sh"]
