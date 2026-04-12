# frozen_string_literal: true

module MicroservicesPlatform
  class UserClient
    def fetch(user_id, token)
      uri = URI("#{ENV.fetch('USER_SERVICE_URL')}/users/#{user_id}")
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{token}"

      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      JSON.parse(response.body)
    end
  end
end
