# frozen_string_literal: true

RSpec.describe LightweightWebFramework::Application do
  it 'routes a request through middleware blocks' do
    request = LightweightWebFramework::Request.new(verb: 'GET', path: '/', headers: {})
    response = described_class.new.tap do |app|
      app.use do |_request, next_app|
        current = next_app.call(request)
        LightweightWebFramework::Response.build(
          status: current.status,
          body: current.body,
          headers: current.headers.merge('X-Middleware' => 'block')
        )
      end
      app.get('/') { LightweightWebFramework::Response.ok('hello') }
    end.call(request)

    expect(response.status).to eq(200)
    expect(response.body).to eq('hello')
    expect(response.headers).to include('X-Middleware' => 'block')
  end

  it 'routes a request through callable middleware' do
    middleware = lambda do |_request, next_app|
      current = next_app.call(LightweightWebFramework::Request.new(verb: 'GET', path: '/', headers: {}))
      LightweightWebFramework::Response.build(status: current.status, body: current.body,
                                              headers: current.headers.merge('X-Middleware' => 'callable'))
    end

    response = described_class.new.tap do |app|
      app.use(middleware)
      app.get('/') { LightweightWebFramework::Response.ok('hello') }
    end.call(LightweightWebFramework::Request.new(verb: 'GET', path: '/', headers: {}))

    expect(response.headers).to include('X-Middleware' => 'callable')
  end
end
