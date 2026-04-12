# frozen_string_literal: true

RSpec.describe 'Event-driven Platform smoke' do
  before do
    clear_event_driven_platform
  end

  it 'runs the packaged event API and worker executables' do
    port = TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] }
    worker_pid = Process.spawn(
      'bundle',
      'exec',
      'bin/event_driven_worker',
      out: File::NULL,
      err: File::NULL
    )
    api_pid = Process.spawn(
      { 'PORT' => port.to_s },
      'bundle',
      'exec',
      'bin/event_driven_platform',
      out: File::NULL,
      err: File::NULL
    )
    wait_for_http(port)

    Net::HTTP.post(URI("http://127.0.0.1:#{port}/events"), JSON.generate(message: 'Issue opened'))

    expect(wait_for_records("http://127.0.0.1:#{port}/notifications")).not_to be_empty
  ensure
    [api_pid, worker_pid].compact.each do |pid|
      Process.kill('TERM', pid)
      Process.wait(pid)
    end
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

  def wait_for_records(url)
    30.times do
      records = JSON.parse(Net::HTTP.get(URI(url)))
      return records unless records.empty?

      sleep 0.1
    end

    raise "no records at #{url}"
  end
end
