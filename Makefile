build:
	docker compose build
up:
	docker compose up -d
down:
	docker compose stop
restart:
	$(MAKE) down
	$(MAKE) up
ps:
	docker compose ps
bash:
	docker compose exec ruby bash