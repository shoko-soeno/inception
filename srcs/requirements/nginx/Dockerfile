# .DockerイメージのベースになるOSを指定する
# NGINX（Webサーバー）と openssl（証明書作成）をインストール
# NGINX の初期設定と SSL証明書作成のためのスクリプトをコンテナ内にコピーする
# NGINXコンテナを起動し、nginxを実行する
# NGINX の設定 (nginx.conf) は、頻繁に変更する可能性が高いため、
# マウントしてすぐ反映できるようにdocker-compose.ymlでマウントしており、ここではコンテナにコピーしない

# FROM alpine:03.18.5
FROM debian:bullseye

# Install nginxとopenssl(TLS証明書のため)
RUN apt-get update && apt-get install -y nginx openssl && apt-get clean && rm -rf /var/lib/apt/lists/*
# コンテナ起動時に実行する初期化スクリプトコピー
COPY ./tools/init.sh /etc/nginx/init.sh
RUN chmod +x /etc/nginx/init.sh
ENTRYPOINT ["/etc/nginx/init.sh"]
