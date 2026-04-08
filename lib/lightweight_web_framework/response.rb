# frozen_string_literal: true

module LightweightWebFramework
  DEFAULT_RESPONSE_HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  Response = Data.define(:status, :headers, :body) do
    def self.build(status:, body:, headers: {})
      new(status:, headers: DEFAULT_RESPONSE_HEADERS.merge(headers), body:)
    end

    def self.ok(body, headers: {})
      build(status: 200, body:, headers:)
    end

    def self.not_found
      build(status: 404, body: 'Not Found')
    end
  end
end
