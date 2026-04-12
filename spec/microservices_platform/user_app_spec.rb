# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::UserApp do
  let(:request) { Rack::MockRequest.new(described_class.new) }

  it 'returns a user for authenticated service requests' do
    response = request.get('/users/1', 'HTTP_AUTHORIZATION' => "Bearer #{MicroservicesPlatform::TOKEN}")

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq('id' => '1', 'name' => 'User 1')
  end

  it 'rejects unauthenticated service requests' do
    response = request.get('/users/1')

    expect(response.status).to eq(401)
    expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
  end

  it 'returns not found for unsupported requests' do
    expect(request.post('/users/1').status).to eq(404)
    expect(request.get('/missing').status).to eq(404)
  end
end
