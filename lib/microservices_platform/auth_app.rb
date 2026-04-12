# frozen_string_literal: true

module MicroservicesPlatform
  class AuthApp
    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze

    def call(env)
      if env.fetch('REQUEST_METHOD') == 'POST' && env.fetch('PATH_INFO') == '/tokens'
        return [200, HEADERS, [JSON.generate(token: TOKEN)]]
      end

      NOT_FOUND
    end
  end
end
