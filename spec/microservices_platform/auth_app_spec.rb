# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::AuthApp do
  let(:request) { Rack::MockRequest.new(described_class.new) }

  it 'issues a service token' do
    response = request.post('/tokens')

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq('token' => MicroservicesPlatform::TOKEN)
  end

  it 'returns not found for unsupported requests' do
    expect(request.get('/tokens').status).to eq(404)
    expect(request.post('/missing').status).to eq(404)
  end
end
