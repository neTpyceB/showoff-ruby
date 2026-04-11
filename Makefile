.PHONY: build lint test smoke

build:
	docker compose build

lint:
	docker compose run --rm --entrypoint bundle app exec rubocop

test:
	docker compose up --wait -d db
	docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec ruby bin/rest_api_migrate
	docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec rspec

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
	docker compose up -d rest_api
	sh -c 'trap "docker compose down" EXIT; \
		until curl --fail --silent --show-error http://127.0.0.1:3000/api/posts >/tmp/showoff-ruby-api-unauthorized.out 2>/dev/null; do if grep -q "Unauthorized" /tmp/showoff-ruby-api-unauthorized.out 2>/dev/null; then break; fi; sleep 1; done; \
		ruby -rnet/http -rjson -e '\''uri=URI("http://127.0.0.1:3000"); http=Net::HTTP.new(uri.host, uri.port); user=http.post("/api/users", JSON.generate({email:"user@example.com",password:"secret"}), {"Content-Type"=>"application/json"}); abort(user.body) unless user.code=="201"; session=http.post("/api/session", JSON.generate({email:"user@example.com",password:"secret"}), {"Content-Type"=>"application/json"}); abort(session.body) unless session.code=="200"; token=JSON.parse(session.body).fetch("token"); create=http.post("/api/posts", JSON.generate({title:"Hello",body:"World"}), {"Content-Type"=>"application/json","Authorization"=>"Bearer #{token}"}); abort(create.body) unless create.code=="201"; list=http.get("/api/posts?page=1&per_page=10", {"Authorization"=>"Bearer #{token}"}); abort(list.body) unless list.code=="200" && JSON.parse(list.body).fetch("items").length==1'\'''
