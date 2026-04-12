# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::GatewayApp do
  let(:auth_client) { instance_double(MicroservicesPlatform::AuthClient, token: 'token') }
  let(:user_client) { instance_double(MicroservicesPlatform::UserClient, fetch: { 'id' => '1', 'name' => 'User 1' }) }
  let(:worker_client) { instance_double(MicroservicesPlatform::WorkerClient, process: { 'user_id' => '1', 'status' => 'processed' }) }
  let(:request) { Rack::MockRequest.new(described_class.new(auth_client:, user_client:, worker_client:)) }

  it 'serves the gateway page' do
    response = request.get('/')

    expect(response.status).to eq(200)
    expect(response.body).to include('Microservices platform', '/api/users/1')
  end

  it 'composes auth, user, and worker service responses' do
    response = request.get('/api/users/1')

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq(
      'user' => { 'id' => '1', 'name' => 'User 1' },
      'job' => { 'user_id' => '1', 'status' => 'processed' }
    )
    expect(user_client).to have_received(:fetch).with('1', 'token')
    expect(worker_client).to have_received(:process).with('1')
  end

  it 'returns not found for unsupported paths' do
    expect(request.get('/api/users/me').status).to eq(404)
  end
end
