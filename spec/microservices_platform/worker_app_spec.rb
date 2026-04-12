# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::WorkerApp do
  let(:request) { Rack::MockRequest.new(described_class.new) }

  it 'processes a job' do
    response = request.post('/jobs', input: JSON.generate(user_id: '1'))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq('user_id' => '1', 'status' => 'processed')
  end

  it 'returns not found for unsupported requests' do
    expect(request.get('/jobs').status).to eq(404)
    expect(request.post('/missing').status).to eq(404)
  end
end
