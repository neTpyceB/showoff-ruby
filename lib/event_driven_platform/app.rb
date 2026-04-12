# frozen_string_literal: true

module EventDrivenPlatform
  class App
    HTML = <<~HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Event-driven Platform</title>
          <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #f7f8fa; color: #111827; }
            main { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
            code { background: #e5e7eb; border-radius: 6px; padding: 2px 6px; }
          </style>
        </head>
        <body>
          <main>
            <h1>Event-driven platform</h1>
            <p>Post <code>{"message":"Issue opened"}</code> to <code>/events</code>.</p>
          </main>
        </body>
      </html>
    HTML

    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    HTML_HEADERS = { 'Content-Type' => 'text/html' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze
    READ_MODELS = {
      '/activity' => ActivityFeed,
      '/audit' => AuditLog,
      '/notifications' => NotificationService
    }.freeze

    def initialize(bus: Bus.new)
      @bus = bus
    end

    def call(env)
      request = Rack::Request.new(env)

      return [200, HTML_HEADERS, [HTML]] if request.get? && request.path_info == '/'
      return publish(request) if request.post? && request.path_info == '/events'

      read_model(request) || NOT_FOUND
    end

    private

    def publish(request)
      [202, HEADERS, [JSON.generate(@bus.publish(JSON.parse(request.body.read).fetch('message')))]]
    end

    def read_model(request)
      model = READ_MODELS[request.path_info]
      [200, HEADERS, [JSON.generate(model.all)]] if request.get? && model
    end
  end
end
