# # A Makefile must set up your entire application 
# # (i.e., it has to build the Docker images using docker-compose.yml).
# COMPOSE_FILE = srcs/docker-compose.yml

# # .env is used to set environment variables for the docker-compose command.
# ENV_FILE = srcs/.env

# start:
# 	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d

# stop:
# 	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop

# # -f: specifies the Compose file to use.
# # -d: detached mode, which runs containers in the background.
# # --build: to build images before starting containers.
# # --env-file: specifies the file containing environment variables.
# up:
# 	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

# # 停止：すべてのコンテナ停止
# down:
# 	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down

# # down → up
# restart: down up

# # -v is a option of docker-compose down to remove volumes with the containers.
# # so that data is not persisted.
# # --remove-orphans removes containers for services not defined in the Compose file(docker-compose.yml).
# # --rmi all means to remove all images used by any service.
# clean:
# 	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down -v --rmi all --remove-orphans

# .PHONY: up down restart clean

#---------------------------------------
all: up

prepare:
	mkdir -p $(HOME)/data/db_data $(HOME)/data/wp_data $(HOME)/data/ssl_certs

build:
	cd srcs && docker compose build

up: prepare build
	cd srcs && docker compose up -d

down:
	cd srcs && docker compose down

stop:
	cd srcs && docker compose stop

clean:
	cd srcs && docker compose down -v --rmi all --remove-orphans

fclean: clean
	sudo rm -rf $(HOME)/data/

re: fclean up

.PHONY: all prepare build up down stop clean fclean re