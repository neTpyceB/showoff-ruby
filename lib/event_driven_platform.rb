# frozen_string_literal: true

require 'json'
require 'rack'
require 'redis'

require_relative 'event_driven_platform/activity_feed'
require_relative 'event_driven_platform/audit_log'
require_relative 'event_driven_platform/bus'
require_relative 'event_driven_platform/notification_service'
require_relative 'event_driven_platform/processor'
require_relative 'event_driven_platform/worker'
require_relative 'event_driven_platform/app'

module EventDrivenPlatform
  def self.app
    App.new
  end

  def self.redis
    @redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'redis://cache:6379/0'))
  end

  def self.worker
    bus = Bus.new
    Worker.new(bus:, processor: Processor.new(bus:, handlers: handlers))
  end

  def self.handlers
    [
      NotificationService.new,
      ActivityFeed.new,
      AuditLog.new
    ]
  end
end
