# frozen_string_literal: true

module AutomationToolkit
  class CLI
    def initialize(argv:, out: $stdout, err: $stderr)
      @argv = argv
      @out = out
      @err = err
    end

    def call
      configuration = ArgumentParser.new(argv).call
      Runner.new(configuration:, out:, err:).call
      0
    rescue AutomationToolkit::Error, OptionParser::ParseError, KeyError => e
      err.puts(e.message)
      1
    end

    private

    attr_reader :argv, :out, :err
  end
end
