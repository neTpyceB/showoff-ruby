# frozen_string_literal: true

RSpec.describe 'Event-driven Platform flow' do
  before do
    clear_event_driven_platform
  end

  it 'publishes one event and projects notifications, activity, and audit records' do
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

    uri = URI("http://127.0.0.1:#{port}")
    event = JSON.parse(
      Net::HTTP.post(URI("#{uri}/events"), JSON.generate(message: 'Issue opened')).body
    )
    notifications = wait_for_records("#{uri}/notifications")
    activity = wait_for_records("#{uri}/activity")
    audit = wait_for_records("#{uri}/audit")

    expect(event).to include('message' => 'Issue opened', 'attempts' => 0)
    expect(notifications).to eq([{ 'event_id' => event.fetch('id'), 'message' => 'Notification: Issue opened' }])
    expect(activity).to eq([{ 'event_id' => event.fetch('id'), 'message' => 'Activity: Issue opened' }])
    expect(audit).to eq([{ 'event_id' => event.fetch('id'), 'message' => 'Issue opened', 'attempts' => 0 }])
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
