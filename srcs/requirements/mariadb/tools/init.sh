# WordPress用のデータベースを作成
# 初回起動時に必要なSQLファイルを作る

# DBの初期設定（データベースとユーザーを作成、権限を設定）
# 設定ファイルに以下を書き込む
# 「もし指定のDBがなければ新しく作る」
# 「もし指定のユーザーがなければ作り、パスワードを設定する」
# 「作成されたユーザーに指定のDBへの全ての権限を与える」
# 「ユーザーの権限情報を更新する」
# MariaDBを起動して、設定ファイルの内容で初期化する

#!/bin/sh
set -ex

init_db() {
	if [ ! -d "/var/lib/mysql/mysql" ]; then
		echo "Initializing database..."
		mariadb-install-db --user=mysql --datadir=/var/lib/mysql
		echo "Database initialized successfully"
	else
		echo "Database already initialized"
	fi
}

run_temp_mariadb() {
	if ! pgrep mariadbd >/dev/null; then
		mariadbd --user=mysql --datadir=/var/lib/mysql &
		sleep 3
	fi
}

kill_temp_mariadb() {
	if pgrep mariadbd >/dev/null; then
		killall mariadbd
		while pgrep mariadbd >/dev/null; do
			sleep 1
		done
	fi
}

# TODO: Provide appropriate privileges
create_user() {
	if [ $# -ne 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
		echo "Failed to create user: invalid arguments"
		exit 1
	fi
	if ! mariadb -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$1');" | grep -q 1; then
		echo "Creating user '$1'..."
		mariadb -u root <<-EOSQL
			CREATE USER '$1'@'%' IDENTIFIED BY '$2';
			CREATE USER '$1'@'localhost' IDENTIFIED BY '$2';
			GRANT ALL PRIVILEGES ON *.* TO '$1'@'%' WITH GRANT OPTION;
			GRANT ALL PRIVILEGES ON *.* TO '$1'@'localhost' WITH GRANT OPTION;
			FLUSH PRIVILEGES;
		EOSQL
		echo "User '$1' created successfully"
	else
		echo "User '$1' already exists"
	fi
}

create_database() {
	if [ $# -ne 1 ] || [ -z "$1" ]; then
		echo "Failed to create database: invalid arguments"
		exit 1
	fi
	if ! mariadb -u root -sse "SHOW DATABASES LIKE '$1';" | grep -q "$1"; then
		echo "Creating database '$1'..."
		mariadb -u root <<-EOSQL
			CREATE DATABASE IF NOT EXISTS \`$1\`;
		EOSQL
		echo "Database '$1' created successfully"
	else
		echo "Database '$1' already exists"
	fi
}

main() {
	init_db
	run_temp_mariadb
	if [ -n "$DB_DATABASE" ]; then
		create_database "$DB_DATABASE"
	fi
	if [ -n "$DB_USER" ] && [ -n "$DB_PASSWORD" ]; then
		create_user "$DB_USER" "$DB_PASSWORD"
	fi
	kill_temp_mariadb

	# Start mariadb
	exec mariadbd-safe --user=mysql --datadir=/var/lib/mysql
}

main


