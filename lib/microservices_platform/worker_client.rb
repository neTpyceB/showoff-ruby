# frozen_string_literal: true

module MicroservicesPlatform
  class WorkerClient
    def process(user_id)
      response = Net::HTTP.post(
        URI("#{ENV.fetch('WORKER_SERVICE_URL')}/jobs"),
        JSON.generate(user_id:),
        'Content-Type' => 'application/json'
      )
      JSON.parse(response.body)
    end
  end
end
