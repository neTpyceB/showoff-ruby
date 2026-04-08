# frozen_string_literal: true

module LightweightWebFramework
  class Application
    def initialize(router: Router.new)
      @router = router
      @middlewares = []
    end

    def use(middleware = nil, &block)
      middlewares << (middleware || block)
    end

    def get(path, &)
      router.get(path, &)
    end

    def call(request)
      middlewares.reverse.reduce(router.method(:call)) do |next_app, middleware|
        ->(current_request) { middleware.call(current_request, next_app) }
      end.call(request)
    end

    private

    attr_reader :router, :middlewares
  end
end
