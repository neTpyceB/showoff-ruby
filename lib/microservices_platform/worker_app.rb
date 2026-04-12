# frozen_string_literal: true

module MicroservicesPlatform
  class WorkerApp
    HEADERS = { 'Content-Type' => 'application/json' }.freeze
    NOT_FOUND = [404, { 'Content-Type' => 'text/plain' }, ['Not Found']].freeze

    def call(env)
      return NOT_FOUND unless env.fetch('REQUEST_METHOD') == 'POST' && env.fetch('PATH_INFO') == '/jobs'

      payload = JSON.parse(env.fetch('rack.input').read)
      [200, HEADERS, [JSON.generate(user_id: payload.fetch('user_id'), status: 'processed')]]
    end
  end
end
