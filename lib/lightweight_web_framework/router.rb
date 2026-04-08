# frozen_string_literal: true

module LightweightWebFramework
  class Router
    Route = Data.define(:verb, :path, :action)

    def initialize
      @routes = []
    end

    def get(path, &action)
      routes << Route.new(verb: 'GET', path:, action:)
    end

    def call(request)
      route = routes.find { |entry| entry.verb == request.verb && entry.path == request.path }
      return Response.not_found unless route

      route.action.call(request)
    end

    private

    attr_reader :routes
  end
end
