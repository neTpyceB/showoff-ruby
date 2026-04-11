# frozen_string_literal: true

module HighPerformanceService
  module Cache
    KEY_PREFIX = 'high_performance:fibonacci:'

    def self.fetch(input)
      key = "#{KEY_PREFIX}#{input}"
      cached = redis.get(key)
      return [Integer(cached), true] if cached

      result = Calculator.fibonacci(input)
      redis.set(key, result.to_s)
      [result, false]
    end

    def self.redis
      @redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'redis://cache:6379/0'))
    end
  end
end
