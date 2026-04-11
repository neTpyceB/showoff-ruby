# frozen_string_literal: true

module HighPerformanceService
  module Calculator
    def self.fibonacci(input)
      previous = 0
      current = 1

      input.times do
        previous, current = current, previous + current
      end

      previous
    end
  end
end
