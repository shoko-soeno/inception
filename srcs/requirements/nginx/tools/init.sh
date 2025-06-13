# 秘密鍵（SSL通信を暗号化するためのもの）を作成
# 証明書署名リクエストを作成
# 自己署名証明書を作成
# Nginxをデーモンモードではなくフォアグラウンドで起動
# ※コンテナが終了しないようにする

#!/bin/sh
set -ex

# Create certificate
if [ ! -e /etc/ssl/private/inception.key ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=42Tokyo/CN=inception" \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt
fi

# Start nginx
exec nginx -g "daemon off;"
