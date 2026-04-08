# frozen_string_literal: true

module DslBuilder
  class CLI
    USAGE = 'usage: run --file FILE --task TASK'

    def initialize(argv:, out: $stdout, err: $stderr)
      @argv = argv.dup
      @out = out
      @err = err
    end

    def call
      configuration = parse
      registry = Loader.new.call(configuration.file)
      Executor.new(registry:, out:, working_directory: File.dirname(configuration.file)).call(configuration.task)
      0
    rescue DslBuilder::Error, OptionParser::ParseError, KeyError => e
      err.puts(e.message)
      1
    end

    private

    attr_reader :argv, :out, :err

    def parse
      command = argv.shift or raise Error, USAGE
      raise Error, USAGE unless command == 'run'

      values = {}

      OptionParser.new do |parser|
        parser.on('--file FILE') { |file| values[:file] = file }
        parser.on('--task TASK') { |task| values[:task] = task }
      end.parse!(argv)

      Configuration.new(command:, file: values.fetch(:file), task: values.fetch(:task))
    end
  end
end
