# frozen_string_literal: true

RSpec.describe 'Microservices Platform flow' do
  it 'routes a gateway request through auth, user, and worker services' do
    ports = 4.times.map { TCPServer.open('127.0.0.1', 0) { |server| server.addr[1] } }
    auth_port, user_port, worker_port, gateway_port = ports
    pids = [
      spawn_service('bin/microservices_auth', auth_port),
      spawn_service('bin/microservices_user', user_port),
      spawn_service('bin/microservices_worker', worker_port),
      spawn_service(
        'bin/microservices_gateway',
        gateway_port,
        'AUTH_SERVICE_URL' => "http://127.0.0.1:#{auth_port}",
        'USER_SERVICE_URL' => "http://127.0.0.1:#{user_port}",
        'WORKER_SERVICE_URL' => "http://127.0.0.1:#{worker_port}"
      )
    ]
    ports.each { |port| wait_for_http(port) }
    wait_for_http(gateway_port)

    root = Net::HTTP.get_response(URI("http://127.0.0.1:#{gateway_port}/"))
    response = JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:#{gateway_port}/api/users/1")))

    expect(root.body).to include('Microservices platform')
    expect(response).to eq(
      'user' => { 'id' => '1', 'name' => 'User 1' },
      'job' => { 'user_id' => '1', 'status' => 'processed' }
    )
  ensure
    pids&.each do |pid|
      Process.kill('TERM', pid)
      Process.wait(pid)
    end
  end

  def spawn_service(command, port, environment = {})
    Process.spawn(
      { 'PORT' => port.to_s }.merge(environment),
      'bundle',
      'exec',
      command,
      out: File::NULL,
      err: File::NULL
    )
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
