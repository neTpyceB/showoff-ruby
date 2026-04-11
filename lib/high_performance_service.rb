# frozen_string_literal: true

require 'json'
require 'objspace'
require 'rack'
require 'redis'

require_relative 'high_performance_service/app'
require_relative 'high_performance_service/cache'
require_relative 'high_performance_service/calculator'
require_relative 'high_performance_service/profiler'

module HighPerformanceService
  def self.app
    App.new
  end
end
