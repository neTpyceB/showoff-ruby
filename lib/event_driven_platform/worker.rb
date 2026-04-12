# frozen_string_literal: true

module EventDrivenPlatform
  class Worker
    def initialize(bus:, processor:)
      @bus = bus
      @processor = processor
    end

    def tick
      @bus.read.each do |id, fields|
        @processor.call(id, JSON.parse(fields.fetch('event')))
        @bus.ack(id)
      end
    end
  end
end
