#!/bin/bash

# エラー発生時に即終了させる
set -ex

# SSL証明書の保存先移動
cd /etc/nginx/ssl

# 秘密鍵作成(NISTなどのセキュリティ機関が2048bit以上を推奨しており、パフォーマンスバランスがいいためこちらを指定)
openssl genrsa -out inception.key 2048
# CSR(証明書署名要求リクエスト)作成 CNはCommon Nameの略で、証明書の所有者を識別するための名前
# openssl req -new -key inception.key -out inception.csr -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42Tokyo/CN=ssoeno.42.fr"
openssl req -new -key inception.key -out inception.csr -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42Tokyo/CN=localhost"
# CSRから自己署名証明書を作成
openssl x509 -req -days 365 -in inception.csr -signkey inception.key -out inception.crt
# # Create certificate
# if [ ! -f inception.key ] || [ ! -f inception.crt ]; then
#     openssl genrsa -out inception.key 2048
#     openssl req -new -key inception.key -out inception.csr -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42Tokyo/CN=ssoeno.42.fr"
#     openssl x509 -req -days 365 -in inception.csr -signkey inception.key -out inception.crt
# fi

# Nginxをデーモンモードではなくフォアグラウンドで起動　※コンテナが終了しないようにする
exec nginx -g 'daemon off;'
