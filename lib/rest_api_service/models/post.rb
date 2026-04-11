# frozen_string_literal: true

module RestApiService
  module Models
    class Post < Sequel::Model(RestApiService::Database.connection[:posts])
      plugin :validation_helpers

      def validate
        super
        validates_presence %i[title body]
      end

      def before_validation
        self.created_at ||= Time.now
        self.updated_at = Time.now
        super
      end
    end
  end
end
