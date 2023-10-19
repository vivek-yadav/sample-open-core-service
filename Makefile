compose-build:
	@echo "building docker images"
	docker compose build --progress=plain

closed-compose-build:
	@echo "building docker images"
	BUILD_ARGS="-tags closed" docker compose build --progress=plain

compose-run: compose-build
	@echo "running docker compose in background"
	docker compose up -d
	-open "http://localhost:9090/swagger"

compose-stop:
	@echo "stopping docker compose in background"
	docker compose down

compose-up: compose-build
	@echo "running docker compose in forground"
	docker compose up

closed-compose-up: closed-compose-build
	@echo "running docker compose in forground"
	docker compose up


