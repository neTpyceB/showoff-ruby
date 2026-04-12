# frozen_string_literal: true

module MicroservicesPlatform
  class UserApp
    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze
    UNAUTHORIZED = [401, HEADERS, [JSON.generate(error: 'Unauthorized')]].freeze

    def call(env)
      match = env.fetch('PATH_INFO').match(%r{\A/users/(\d+)\z})
      return NOT_FOUND unless env.fetch('REQUEST_METHOD') == 'GET' && match
      return UNAUTHORIZED unless env['HTTP_AUTHORIZATION'] == "Bearer #{TOKEN}"

      id = match[1]
      [200, HEADERS, [JSON.generate(id:, name: "User #{id}")]]
    end
  end
end
