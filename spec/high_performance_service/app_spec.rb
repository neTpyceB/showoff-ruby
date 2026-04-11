# frozen_string_literal: true

RSpec.describe HighPerformanceService::App do
  before do
    HighPerformanceService::Cache.redis.flushdb
  end

  it 'serves the browser page' do
    response = Rack::MockRequest.new(described_class.new).get('/')

    expect(response.status).to eq(200)
    expect(response.body).to include('High-performance service', '/work?input=35')
  end

  it 'returns profiled work with Redis cache state' do
    request = Rack::MockRequest.new(described_class.new)

    miss = JSON.parse(request.get('/work?input=10').body)
    hit = JSON.parse(request.get('/work?input=10').body)

    expect(miss).to include('input' => 10, 'result' => 55, 'cached' => false)
    expect(miss.fetch('profile')).to include('cpu_ns', 'allocated_objects', 'memory_bytes')
    expect(hit).to include('input' => 10, 'result' => 55, 'cached' => true)
  end

  it 'returns not found for unknown paths' do
    response = Rack::MockRequest.new(described_class.new).get('/missing')

    expect(response.status).to eq(404)
    expect(response.body).to eq('Not Found')
  end
end
