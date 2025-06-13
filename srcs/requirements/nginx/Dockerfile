# DockerイメージのベースになるOSを指定する
# NGINX（Webサーバー）と openssl（証明書作成）をインストール
# NGINX の初期設定と SSL証明書作成のためのスクリプトをコンテナ内にコピーする
# NGINXコンテナを起動し、nginxを実行する

# NGINX の設定 (nginx.conf) は、頻繁に変更する可能性が高いため、
# マウントしてすぐ反映できるようにdocker-compose.ymlでマウントしており、ここではコンテナにコピーしない