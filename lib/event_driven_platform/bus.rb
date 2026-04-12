# frozen_string_literal: true

module EventDrivenPlatform
  class Bus
    STREAM = 'event_driven:events'
    OFFSET_KEY = 'event_driven:offset'
    FAILED_KEY = 'event_driven:failed'
    MAX_ATTEMPTS = 2

    def initialize(redis: EventDrivenPlatform.redis)
      @redis = redis
    end

    def publish(message, attempts: 0)
      payload = { 'message' => message, 'attempts' => attempts }
      id = @redis.xadd(STREAM, { 'event' => JSON.generate(payload) })

      payload.merge('id' => id)
    end

    def read
      Hash(@redis.xread([STREAM], [@redis.get(OFFSET_KEY) || '0-0'], count: 1))[STREAM].to_a
    end

    def ack(id)
      @redis.set(OFFSET_KEY, id)
    end

    def retry(event, error)
      attempts = event.fetch('attempts').to_i + 1
      failure = event.merge('attempts' => attempts, 'error' => error.message)

      if attempts < MAX_ATTEMPTS
        publish(failure.fetch('message'), attempts:)
      else
        @redis.lpush(FAILED_KEY, JSON.generate(failure))
      end

      failure
    end

    def failed
      @redis.lrange(FAILED_KEY, 0, -1).map { |record| JSON.parse(record) }
    end
  end
end
