# frozen_string_literal: true

RSpec.describe HighPerformanceService do
  it 'builds the Rack application' do
    response = Rack::MockRequest.new(described_class.app).get('/')

    expect(response.status).to eq(200)
  end
end
