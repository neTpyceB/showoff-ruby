# frozen_string_literal: true

module LightweightWebFramework
  module DemoApp
    REQUEST_METHOD_HEADER = lambda do |request, next_app|
      response = next_app.call(request)

      Response.build(
        status: response.status,
        body: response.body,
        headers: response.headers.merge('X-Request-Method' => request.verb)
      )
    end

    module_function

    def build
      Application.new.tap do |app|
        app.use(REQUEST_METHOD_HEADER)
        app.get('/') { Response.ok('lightweight web framework') }
      end
    end
  end
end
