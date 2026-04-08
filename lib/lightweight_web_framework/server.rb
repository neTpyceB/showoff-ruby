# frozen_string_literal: true

module LightweightWebFramework
  class Server
    def initialize(app:, port:, server_class: WEBrick::HTTPServer, logger: WEBrick::Log.new($stderr, WEBrick::Log::WARN))
      @app = app
      @port = port
      @server_class = server_class
      @logger = logger
    end

    def start
      @server = server_class.new(AccessLog: [], BindAddress: '0.0.0.0', Logger: logger, Port: port)
      server.mount_proc('/') do |raw_request, raw_response|
        response = app.call(build_request(raw_request))
        write_response(raw_response, response)
      end
      server.start
    end

    def stop
      server&.shutdown
    end

    private

    attr_reader :app, :port, :server_class, :logger, :server

    def build_request(raw_request)
      Request.new(
        verb: raw_request.request_method,
        path: raw_request.path,
        headers: raw_request.header.transform_values(&:first)
      )
    end

    def write_response(raw_response, response)
      raw_response.status = response.status
      response.headers.each { |key, value| raw_response[key] = value }
      raw_response.body = response.body
    end
  end
end
