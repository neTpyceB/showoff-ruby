# frozen_string_literal: true

RSpec.describe 'Lightweight Web Framework smoke' do
  it 'runs the packaged web framework executable' do
    port = TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] }
    pid = Process.spawn(
      { 'PORT' => port.to_s },
      'bundle',
      'exec',
      'bin/lightweight_web_framework',
      out: File::NULL,
      err: File::NULL
    )
    wait_for_http(port)

    response = Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/"))

    expect(response.code).to eq('200')
    expect(response.body).to eq('lightweight web framework')
    expect(response['X-Request-Method']).to eq('GET')
  ensure
    Process.kill('TERM', pid) if pid
    Process.wait(pid) if pid
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
