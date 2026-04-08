.PHONY: build lint test smoke

build:
	docker compose build

lint:
	docker compose run --rm --entrypoint bundle app exec rubocop

test:
	docker compose run --rm --entrypoint bundle app exec rspec

smoke:
	docker compose run --rm app search --path spec/fixtures/smoke --query alpha
	docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build
