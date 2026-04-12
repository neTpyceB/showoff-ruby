# frozen_string_literal: true

module EventDrivenPlatform
  class AuditLog
    KEY = 'event_driven:audit'

    def initialize(redis: EventDrivenPlatform.redis)
      @redis = redis
    end

    def call(id, event)
      @redis.lpush(KEY, JSON.generate(event.merge('event_id' => id)))
    end

    def self.all(redis: EventDrivenPlatform.redis)
      redis.lrange(KEY, 0, -1).map { |record| JSON.parse(record) }
    end
  end
end
