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
	docker compose up -d web_framework
	sh -c 'trap "docker compose down" EXIT; \
		until curl --fail --silent --show-error http://127.0.0.1:9292/ >/tmp/showoff-ruby-web-root.out; do sleep 1; done; \
		curl --silent --show-error -D /tmp/showoff-ruby-web-headers.out -o /tmp/showoff-ruby-web-missing.out http://127.0.0.1:9292/missing >/tmp/showoff-ruby-web-status.out; \
		grep "lightweight web framework" /tmp/showoff-ruby-web-root.out; \
		grep "HTTP/1.1 404" /tmp/showoff-ruby-web-headers.out; \
		grep "X-Request-Method: GET" /tmp/showoff-ruby-web-headers.out; \
		grep "Not Found" /tmp/showoff-ruby-web-missing.out'
