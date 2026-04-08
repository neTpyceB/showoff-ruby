# frozen_string_literal: true

module AutomationToolkit
  class Runner
    COMMANDS = {
      search: lambda do |configuration, logger|
        Commands::Search.new(path: configuration.path, query: configuration.query, logger:)
      end,
      rename: lambda do |configuration, logger|
        Commands::Rename.new(path: configuration.path, name: configuration.name, logger:)
      end,
      organize: ->(configuration, logger) { Commands::Organize.new(path: configuration.path, logger:) }
    }.freeze

    def initialize(configuration:, out:, err:)
      @configuration = configuration
      @out = out
      @err = err
    end

    def call
      command.call.each { out.puts(it) }
    end

    private

    attr_reader :configuration, :out, :err

    def command
      logger = LoggerFactory.build(level: configuration.log_level, io: err)
      COMMANDS.fetch(configuration.command).call(configuration, logger)
    end
  end
end
