# DockerイメージのベースになるOSを指定する
# NGINX（Webサーバー）と openssl（証明書作成）をインストール
# NGINX の初期設定と SSL証明書作成のためのスクリプトをコンテナ内にコピーする
# NGINXコンテナを起動し、nginxを実行する

# NGINX の設定 (nginx.conf) は、頻繁に変更する可能性が高いため、
# マウントしてすぐ反映できるようにdocker-compose.ymlでマウントしており、ここではコンテナにコピーしない

FROM alpine:3.18.5

# Install nginx
RUN apk update && apk upgrade && apk add nginx openssl

# Copy entrypoint.sh
COPY ./init.sh /usr/local/bin/

# Expose ports
EXPOSE 80 443

# Run entrypoint.sh
ENTRYPOINT ["init.sh"]


