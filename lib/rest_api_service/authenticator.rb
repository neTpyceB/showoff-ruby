# frozen_string_literal: true

module RestApiService
  module Authenticator
    module_function

    def issue(user_id)
      JWT.encode({ user_id: }, secret, 'HS256')
    end

    def decode(token)
      JWT.decode(token, secret, true, algorithm: 'HS256').first
    rescue JWT::DecodeError, NoMethodError
      nil
    end

    def find_user(email, password)
      user = Models::User.first(email:)
      return unless user

      user if user.authenticate?(password)
    end

    def secret
      ENV.fetch('JWT_SECRET')
    end
  end
end
