# frozen_string_literal: true

require 'bcrypt'
require 'json'
require 'jwt'
require 'sequel'
require 'sinatra/base'
require 'time'

require_relative 'rest_api_service/app'
require_relative 'rest_api_service/authenticator'
require_relative 'rest_api_service/database'
require_relative 'rest_api_service/models/post'
require_relative 'rest_api_service/models/user'
require_relative 'rest_api_service/paginator'
require_relative 'rest_api_service/serializers/post_serializer'

module RestApiService
end
