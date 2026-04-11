# frozen_string_literal: true

module RestApiService
  module Models
    class User < Sequel::Model(RestApiService::Database.connection[:users])
      plugin :validation_helpers

      def password=(value)
        self.password_digest = BCrypt::Password.create(value)
      end

      def authenticate?(value)
        BCrypt::Password.new(password_digest) == value
      end

      def validate
        super
        validates_presence %i[email password_digest]
        validates_unique :email
      end

      def before_validation
        self.created_at ||= Time.now
        super
      end
    end
  end
end
