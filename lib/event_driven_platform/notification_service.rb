# frozen_string_literal: true

module EventDrivenPlatform
  class NotificationService
    KEY = 'event_driven:notifications'

    def initialize(redis: EventDrivenPlatform.redis)
      @redis = redis
    end

    def call(id, event)
      @redis.lpush(KEY, JSON.generate('event_id' => id, 'message' => "Notification: #{event.fetch('message')}"))
    end

    def self.all(redis: EventDrivenPlatform.redis)
      redis.lrange(KEY, 0, -1).map { |record| JSON.parse(record) }
    end
  end
end
