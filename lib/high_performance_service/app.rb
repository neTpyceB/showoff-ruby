# frozen_string_literal: true

module HighPerformanceService
  class App
    HTML = <<~HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>High-performance Service</title>
          <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #f8fafc; color: #111827; }
            main { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
            code { background: #e5e7eb; border-radius: 6px; padding: 2px 6px; }
          </style>
        </head>
        <body>
          <main>
            <h1>High-performance service</h1>
            <p>Run <code>/work?input=35</code> twice to see Redis caching and Ruby profiling.</p>
          </main>
        </body>
      </html>
    HTML

    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    HTML_HEADERS = { 'Content-Type' => 'text/html' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze

    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when '/'
        [200, HTML_HEADERS, [HTML]]
      when '/work'
        [200, HEADERS, [JSON.generate(work(Integer(request.params.fetch('input'))))]]
      else
        NOT_FOUND
      end
    end

    private

    def work(input)
      result = nil
      cached = nil
      profile = Profiler.call { result, cached = Cache.fetch(input) }

      {
        input:,
        result:,
        cached:,
        profile:
      }
    end
  end
end
