.PHONY: build lint test smoke

build:
	docker compose build

lint:
	docker compose run --rm --entrypoint bundle app exec rubocop

test:
	docker compose up --wait -d --no-recreate cache db
	docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec ruby bin/rest_api_migrate
	docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec rspec

smoke:
	docker compose run --rm app search --path spec/fixtures/smoke --query alpha
	docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build
	docker compose up -d --no-recreate web_framework
	sh -c ' \
		until curl --fail --silent --show-error http://127.0.0.1:9292/ >/tmp/showoff-ruby-web-root.out; do sleep 1; done; \
		curl --silent --show-error -D /tmp/showoff-ruby-web-headers.out -o /tmp/showoff-ruby-web-missing.out http://127.0.0.1:9292/missing >/tmp/showoff-ruby-web-status.out; \
		grep "lightweight web framework" /tmp/showoff-ruby-web-root.out; \
		grep "HTTP/1.1 404" /tmp/showoff-ruby-web-headers.out; \
		grep "X-Request-Method: GET" /tmp/showoff-ruby-web-headers.out; \
		grep "Not Found" /tmp/showoff-ruby-web-missing.out'
	docker rm -f showoff-ruby-rest-api-smoke >/dev/null 2>&1 || true
	docker compose up --wait -d --no-recreate db
	docker compose run -d --name showoff-ruby-rest-api-smoke -p 3001:3000 rest_api
	sh -c 'trap "docker rm -f showoff-ruby-rest-api-smoke >/dev/null 2>&1 || true" EXIT; \
		until curl --silent --show-error http://127.0.0.1:3001/api/posts >/tmp/showoff-ruby-api-unauthorized.out 2>/dev/null; do if grep -q "Unauthorized" /tmp/showoff-ruby-api-unauthorized.out 2>/dev/null; then break; fi; sleep 1; done; \
		grep "Unauthorized" /tmp/showoff-ruby-api-unauthorized.out; \
		ruby -rnet/http -rjson -e '\''email="user#{Time.now.to_i}@example.com"; uri=URI("http://127.0.0.1:3001"); http=Net::HTTP.new(uri.host, uri.port); user=http.post("/api/users", JSON.generate({email:email,password:"secret"}), {"Content-Type"=>"application/json"}); abort(user.body) unless user.code=="201"; session=http.post("/api/session", JSON.generate({email:email,password:"secret"}), {"Content-Type"=>"application/json"}); abort(session.body) unless session.code=="200"; token=JSON.parse(session.body).fetch("token"); create=http.post("/api/posts", JSON.generate({title:"Hello",body:"World"}), {"Content-Type"=>"application/json","Authorization"=>"Bearer #{token}"}); abort(create.body) unless create.code=="201"; list=http.get("/api/posts?page=1&per_page=10", {"Authorization"=>"Bearer #{token}"}); abort(list.body) unless list.code=="200" && JSON.parse(list.body).fetch("items").length>=1'\'''
	docker compose up -d --no-recreate realtime_collaboration
	sh -c ' \
		until curl --fail --silent --show-error http://127.0.0.1:9393/ >/tmp/showoff-ruby-realtime-root.out; do sleep 1; done; \
		grep "Shared workspace" /tmp/showoff-ruby-realtime-root.out; \
		docker compose run --rm --entrypoint bundle app exec ruby -rwebsocket-client-simple -rjson -e '\''messages=Queue.new; ws=WebSocket::Client::Simple.connect("ws://realtime_collaboration:9393/cable", headers: {"Origin"=>"http://localhost:9393"}); ws.on(:message){|event| messages << JSON.parse(event.data)}; deadline=Time.now+5; loop do; frame=messages.pop(true) rescue nil; break if frame && frame["type"]=="welcome"; abort("welcome timeout") if Time.now>deadline; sleep 0.05; end; identifier=JSON.generate(channel:"RealtimeCollaboration::CollaborationChannel"); ws.send(JSON.generate(command:"subscribe", identifier:identifier)); deadline=Time.now+5; loop do; frame=messages.pop(true) rescue nil; payload=frame["message"] if frame && frame["message"].is_a?(Hash); break if payload && payload["type"]=="state"; abort("state timeout") if Time.now>deadline; sleep 0.05; end; ws.send(JSON.generate(command:"message", identifier:identifier, data:JSON.generate(action:"update", content:"Hello"))); deadline=Time.now+5; state=false; notice=false; until state && notice; frame=messages.pop(true) rescue nil; payload=frame["message"] if frame && frame["message"].is_a?(Hash); state ||= payload && payload["type"]=="state" && payload["state"]["content"]=="Hello"; notice ||= payload && payload["type"]=="notification" && payload["message"]=="Document updated"; abort("update timeout") if Time.now>deadline; sleep 0.05; end; ws.close'\'''
	docker compose up -d --no-recreate cache high_performance
	docker compose exec -T cache redis-cli FLUSHDB
	sh -c ' \
		until curl --fail --silent --show-error http://127.0.0.1:9494/ >/tmp/showoff-ruby-performance-root.out; do sleep 1; done; \
		grep "High-performance service" /tmp/showoff-ruby-performance-root.out; \
		ruby -rnet/http -rjson -e '\''first=JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:9494/work?input=35"))); second=JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:9494/work?input=35"))); abort(first.inspect) unless first["result"]==9227465 && first["cached"]==false && first["profile"].key?("cpu_ns") && first["profile"].key?("allocated_objects") && first["profile"].key?("memory_bytes"); abort(second.inspect) unless second["result"]==9227465 && second["cached"]==true'\'''
	docker compose up -d --no-recreate microservices_gateway
	sh -c ' \
		until curl --fail --silent --show-error http://127.0.0.1:9595/ >/tmp/showoff-ruby-microservices-root.out; do sleep 1; done; \
		grep "Microservices platform" /tmp/showoff-ruby-microservices-root.out; \
		ruby -rnet/http -rjson -e '\''response=JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:9595/api/users/1"))); abort(response.inspect) unless response=={"user"=>{"id"=>"1","name"=>"User 1"},"job"=>{"user_id"=>"1","status"=>"processed"}}'\'''
	docker compose run --rm --entrypoint bundle app exec ruby -rredis -e 'r=Redis.new(url:"redis://cache:6379/0"); keys=r.keys("event_driven:*"); r.del(*keys) unless keys.empty?'
	docker compose up -d --no-recreate event_driven_worker event_driven_platform
	sh -c ' \
		until curl --fail --silent --show-error http://127.0.0.1:9696/ >/tmp/showoff-ruby-events-root.out; do sleep 1; done; \
		grep "Event-driven platform" /tmp/showoff-ruby-events-root.out; \
		ruby -rnet/http -rjson -e '\''base="http://127.0.0.1:9696"; event=JSON.parse(Net::HTTP.post(URI("#{base}/events"), JSON.generate({message:"Issue opened"})).body); deadline=Time.now+5; notifications=[]; activity=[]; audit=[]; until notifications.any? && activity.any? && audit.any?; notifications=JSON.parse(Net::HTTP.get(URI("#{base}/notifications"))); activity=JSON.parse(Net::HTTP.get(URI("#{base}/activity"))); audit=JSON.parse(Net::HTTP.get(URI("#{base}/audit"))); abort("event timeout") if Time.now>deadline; sleep 0.1; end; abort(notifications.inspect) unless notifications==[{"event_id"=>event.fetch("id"),"message"=>"Notification: Issue opened"}]; abort(activity.inspect) unless activity==[{"event_id"=>event.fetch("id"),"message"=>"Activity: Issue opened"}]; abort(audit.inspect) unless audit==[{"event_id"=>event.fetch("id"),"message"=>"Issue opened","attempts"=>0}]'\'''
