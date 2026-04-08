# frozen_string_literal: true

RSpec.describe LightweightWebFramework::Router do
  it 'returns the matching route response' do
    router = described_class.new
    router.get('/') { |request| LightweightWebFramework::Response.ok("#{request.verb} #{request.path}") }

    response = router.call(LightweightWebFramework::Request.new(verb: 'GET', path: '/', headers: {}))

    expect(response.status).to eq(200)
    expect(response.body).to eq('GET /')
  end

  it 'returns a not found response when no route matches' do
    response = described_class.new.call(
      LightweightWebFramework::Request.new(verb: 'GET', path: '/missing', headers: {})
    )

    expect(response.status).to eq(404)
    expect(response.body).to eq('Not Found')
  end
end
