# frozen_string_literal: true

RSpec.describe RealtimeCollaboration::App do
  it 'serves the collaboration page' do
    response = Rack::MockRequest.new(described_class.new).get('/')

    expect(response.status).to eq(200)
    expect(response['Content-Type']).to eq('text/html')
    expect(response.body).to include('Shared workspace', '/cable')
  end

  it 'returns not found for unknown paths' do
    response = Rack::MockRequest.new(described_class.new).get('/missing')

    expect(response.status).to eq(404)
    expect(response.body).to eq('Not Found')
  end
end
