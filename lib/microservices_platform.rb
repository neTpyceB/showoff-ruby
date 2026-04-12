# frozen_string_literal: true

require 'json'
require 'net/http'
require 'rack'

require_relative 'microservices_platform/auth_app'
require_relative 'microservices_platform/auth_client'
require_relative 'microservices_platform/gateway_app'
require_relative 'microservices_platform/user_app'
require_relative 'microservices_platform/user_client'
require_relative 'microservices_platform/worker_app'
require_relative 'microservices_platform/worker_client'

module MicroservicesPlatform
  TOKEN = 'service-token'

  def self.auth_app
    AuthApp.new
  end

  def self.gateway_app
    GatewayApp.new
  end

  def self.user_app
    UserApp.new
  end

  def self.worker_app
    WorkerApp.new
  end
end
