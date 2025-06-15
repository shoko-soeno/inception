# .DockerイメージのベースになるOSを指定する
# NGINX（Webサーバー）と openssl（証明書作成）をインストール
# NGINX の初期設定と SSL証明書作成のためのスクリプトをコンテナ内にコピーする
# NGINXコンテナを起動し、nginxを実行する
# NGINX の設定 (nginx.conf) は、頻繁に変更する可能性が高いため、
# マウントしてすぐ反映できるようにdocker-compose.ymlでマウントしており、ここではコンテナにコピーしない

# FROM alpine:03.18.5
FROM debian:bullseye

# Install nginx
# RUN 
# RUN apk update && apk upgrade && apk add nginx openssl
# パッケージ情報更新、nginxとopenssl(TLS証明書のため)インストール
RUN apt-get update && apt-get install -y nginx openssl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy entrypoint.sh
# COPY ./init.sh /usr/local/bin/

# Expose ports
# EXPOSE 80 443

# コンテナ起動時に実行する初期化スクリプトコピー
COPY ./tools/init.sh /etc/nginx/init.sh
# init.shに実行権限を付与する

RUN chmod +x /etc/nginx/init.sh
# RUN chmod +x ./tools/init.sh

# Run entrypoint.sh
# ENTRYPOINT ["init.sh"]
ENTRYPOINT ["/etc/nginx/init.sh"]
