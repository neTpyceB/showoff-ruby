# frozen_string_literal: true

module AutomationToolkit
  module LoggerFactory
    module_function

    def build(level:, io:)
      Logger.new(io, level:, formatter: method(:format))
    end

    def format(severity, _time, _progname, message)
      "[#{severity}] #{message}\n"
    end
  end
end
