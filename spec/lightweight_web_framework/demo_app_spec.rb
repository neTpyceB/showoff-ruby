# frozen_string_literal: true

RSpec.describe LightweightWebFramework::DemoApp do
  it 'builds the demo application with middleware and a route' do
    response = described_class.build.call(LightweightWebFramework::Request.new(verb: 'GET', path: '/', headers: {}))

    expect(response.status).to eq(200)
    expect(response.body).to eq('lightweight web framework')
    expect(response.headers).to include('X-Request-Method' => 'GET')
  end
end
