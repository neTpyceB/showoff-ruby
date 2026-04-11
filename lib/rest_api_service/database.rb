# frozen_string_literal: true

module RestApiService
  module Database
    module_function

    def connect(url = ENV.fetch('DATABASE_URL'))
      @connection = Sequel.connect(url, max_connections: 5)
    end

    def connection
      @connection || connect
    end
  end
end
