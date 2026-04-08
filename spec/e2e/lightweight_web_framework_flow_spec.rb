# frozen_string_literal: true

RSpec.describe 'Lightweight Web Framework flow' do
  it 'serves responses through real HTTP' do
    port = TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] }
    logger = WEBrick::Log.new(File::NULL, WEBrick::Log::FATAL)
    server = LightweightWebFramework::Server.new(app: LightweightWebFramework::DemoApp.build, port:, logger:)

    thread = Thread.new { server.start }
    wait_for_http(port)

    root_response = Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/"))
    missing_response = Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/missing"))

    expect(root_response.code).to eq('200')
    expect(root_response.body).to eq('lightweight web framework')
    expect(root_response['X-Request-Method']).to eq('GET')
    expect(missing_response.code).to eq('404')
    expect(missing_response.body).to eq('Not Found')
    expect(missing_response['X-Request-Method']).to eq('GET')
  ensure
    server&.stop
    thread&.join
  end

  def wait_for_http(port)
    30.times do
      Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/"))
      return
    rescue Errno::ECONNREFUSED
      sleep 0.1
    end

    raise 'server did not start'
  end
end
