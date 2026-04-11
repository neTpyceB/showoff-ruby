# frozen_string_literal: true

RSpec.describe 'High-performance service flow' do
  before do
    HighPerformanceService::Cache.redis.flushdb
  end

  it 'serves profiled work and Redis cache hits through real HTTP' do
    port = TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] }
    pid = Process.spawn(
      { 'PORT' => port.to_s },
      'bundle',
      'exec',
      'bin/high_performance_service',
      out: File::NULL,
      err: File::NULL
    )
    wait_for_http(port)

    root = Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/"))
    miss = JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:#{port}/work?input=35")))
    hit = JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:#{port}/work?input=35")))

    expect(root.body).to include('High-performance service')
    expect(miss).to include('input' => 35, 'result' => 9_227_465, 'cached' => false)
    expect(miss.fetch('profile')).to include('cpu_ns', 'allocated_objects', 'memory_bytes')
    expect(hit).to include('input' => 35, 'result' => 9_227_465, 'cached' => true)
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
