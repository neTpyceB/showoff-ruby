# frozen_string_literal: true

RSpec.describe 'Realtime Collaboration flow' do
  it 'broadcasts shared state updates and notifications over ActionCable' do
    port = free_port
    pid = spawn_realtime_server(port)
    wait_for_http(port)
    messages = Queue.new
    socket = open_socket(port, messages)
    identifier = JSON.generate(channel: 'RealtimeCollaboration::CollaborationChannel')

    wait_for(messages) { |message| message.fetch('type', nil) == 'welcome' }
    socket.send(JSON.generate(command: 'subscribe', identifier:))
    expect(wait_for(messages) { |message| payload(message)&.fetch('type') == 'state' }.fetch('message').fetch('state'))
      .to eq('content' => '', 'version' => 0)

    socket.send(JSON.generate(command: 'message', identifier:, data: JSON.generate(action: 'update', content: 'Hello')))

    expect(wait_for(messages) { |message| payload(message)&.fetch('type') == 'state' }.fetch('message').fetch('state'))
      .to eq('content' => 'Hello', 'version' => 1)
    notification = wait_for(messages) { |message| payload(message)&.fetch('type') == 'notification' }

    expect(notification.fetch('message').fetch('message'))
      .to eq('Document updated')
  ensure
    socket&.close
    Process.kill('TERM', pid) if pid
    Process.wait(pid) if pid
  end

  def free_port
    TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] }
  end

  def spawn_realtime_server(port)
    Process.spawn({ 'PORT' => port.to_s }, 'bundle', 'exec', 'bin/realtime_collaboration', out: File::NULL, err: File::NULL)
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

  def open_socket(port, messages)
    WebSocket::Client::Simple.connect(
      "ws://127.0.0.1:#{port}/cable",
      headers: { 'Origin' => "http://127.0.0.1:#{port}" }
    ).tap do |socket|
      socket.on(:message) { |event| messages << JSON.parse(event.data) }
    end
  end

  def wait_for(messages, &block)
    deadline = Time.now + 5

    loop do
      message = messages.pop(true)
      return message if block.call(message)
    rescue ThreadError
      raise 'message did not arrive' if Time.now > deadline

      sleep 0.05
    end
  end

  def payload(message)
    message.fetch('message') if message.fetch('message', nil).is_a?(Hash)
  end
end
