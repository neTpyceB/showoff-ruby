# frozen_string_literal: true

module EventDrivenPlatform
  class Processor
    def initialize(bus:, handlers:)
      @bus = bus
      @handlers = handlers
    end

    def call(id, event)
      @handlers.each { |handler| handler.call(id, event) }
    rescue StandardError => e
      @bus.retry(event, e)
    end
  end
end
