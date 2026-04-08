# frozen_string_literal: true

module AutomationToolkit
  class ArgumentParser
    USAGE = 'commands: search, rename, organize'

    def initialize(argv)
      @argv = argv.dup
    end

    def call
      command = argv.shift or raise Error, USAGE

      case command
      when 'search' then configuration_for_search
      when 'rename' then configuration_for_rename
      when 'organize' then configuration_for_organize
      else
        raise Error, USAGE
      end
    end

    private

    attr_reader :argv

    def configuration_for_search
      options = parse(argv) do |parser, values|
        parser.on('--path PATH') { values[:path] = it }
        parser.on('--query QUERY') { values[:query] = it }
      end

      Configuration.new(command: :search, path: options.fetch(:path), query: options.fetch(:query), name: nil,
                        log_level: options.fetch(:log_level))
    end

    def configuration_for_rename
      options = parse(argv) do |parser, values|
        parser.on('--path PATH') { values[:path] = it }
        parser.on('--name NAME') { values[:name] = it }
      end

      Configuration.new(command: :rename, path: options.fetch(:path), query: nil, name: options.fetch(:name),
                        log_level: options.fetch(:log_level))
    end

    def configuration_for_organize
      options = parse(argv) do |parser, values|
        parser.on('--path PATH') { values[:path] = it }
      end

      Configuration.new(command: :organize, path: options.fetch(:path), query: nil, name: nil,
                        log_level: options.fetch(:log_level))
    end

    def parse(arguments)
      values = { log_level: Logger::INFO }

      OptionParser.new do |parser|
        parser.on('--log-level LEVEL') { values[:log_level] = Logger.const_get(it.upcase) }
        yield parser, values
      end.parse!(arguments)

      values
    end
  end
end
