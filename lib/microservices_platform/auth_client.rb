# frozen_string_literal: true

module MicroservicesPlatform
  class AuthClient
    def token
      response = Net::HTTP.post(URI("#{ENV.fetch('AUTH_SERVICE_URL')}/tokens"), '')
      JSON.parse(response.body).fetch('token')
    end
  end
end
