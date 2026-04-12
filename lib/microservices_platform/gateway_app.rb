# frozen_string_literal: true

module MicroservicesPlatform
  class GatewayApp
    HTML = <<~HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Microservices Platform</title>
          <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #f6f7f9; color: #111827; }
            main { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
            code { background: #e5e7eb; border-radius: 6px; padding: 2px 6px; }
          </style>
        </head>
        <body>
          <main>
            <h1>Microservices platform</h1>
            <p>Run <code>/api/users/1</code> through the API gateway.</p>
          </main>
        </body>
      </html>
    HTML
    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    HTML_HEADERS = { 'Content-Type' => 'text/html' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze

    def initialize(auth_client: AuthClient.new, user_client: UserClient.new, worker_client: WorkerClient.new)
      @auth_client = auth_client
      @user_client = user_client
      @worker_client = worker_client
    end

    def call(env)
      request = Rack::Request.new(env)
      return [200, HTML_HEADERS, [HTML]] if request.path_info == '/'

      match = request.path_info.match(%r{\A/api/users/(\d+)\z})
      return NOT_FOUND unless match

      user_id = match[1]
      token = @auth_client.token
      user = @user_client.fetch(user_id, token)
      job = @worker_client.process(user_id)

      [200, HEADERS, [JSON.generate(user:, job:)]]
    end
  end
end
