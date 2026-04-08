# frozen_string_literal: true

RSpec.describe LightweightWebFramework::Server do
  it 'starts the HTTP server and writes request responses' do
    fake_server_class = Class.new do
      attr_reader :mounted_path, :mounted_block, :options, :started, :stopped

      def initialize(**options)
        @options = options
      end

      def mount_proc(path, &block)
        @mounted_path = path
        @mounted_block = block
      end

      def start
        @started = true
      end

      def shutdown
        @stopped = true
      end
    end
    fake_response_class = Class.new do
      attr_accessor :status, :body

      def initialize
        @headers = {}
      end

      def []=(key, value)
        @headers[key] = value
      end

      def [](key)
        @headers[key]
      end
    end
    app = ->(request) { LightweightWebFramework::Response.ok("#{request.verb} #{request.path}") }
    logger = WEBrick::Log.new(File::NULL, WEBrick::Log::FATAL)
    server = described_class.new(app:, port: 9292, server_class: fake_server_class, logger:)

    server.start

    fake_server = server.instance_variable_get(:@server)
    raw_request = Struct.new(:request_method, :path, :header).new('GET', '/', { 'host' => ['localhost'] })
    raw_response = fake_response_class.new

    fake_server.mounted_block.call(raw_request, raw_response)

    expect(fake_server.options).to include(BindAddress: '0.0.0.0', Port: 9292)
    expect(fake_server.mounted_path).to eq('/')
    expect(fake_server.started).to be(true)
    expect(raw_response.status).to eq(200)
    expect(raw_response['Content-Type']).to eq('text/plain')
    expect(raw_response.body).to eq('GET /')
  end

  it 'stops the HTTP server' do
    fake_server_class = Class.new do
      attr_reader :stopped

      def initialize(**_options); end

      def mount_proc(_path, &); end

      def start; end

      def shutdown
        @stopped = true
      end
    end
    logger = WEBrick::Log.new(File::NULL, WEBrick::Log::FATAL)
    server = described_class.new(app: ->(_request) { LightweightWebFramework::Response.ok('ok') }, port: 9292,
                                 server_class: fake_server_class, logger:)

    server.start
    server.stop

    expect(server.instance_variable_get(:@server).stopped).to be(true)
  end

  it 'allows stop before start' do
    logger = WEBrick::Log.new(File::NULL, WEBrick::Log::FATAL)
    server = described_class.new(app: ->(_request) { LightweightWebFramework::Response.ok('ok') }, port: 9292,
                                 logger:)

    expect { server.stop }.not_to raise_error
  end
end
