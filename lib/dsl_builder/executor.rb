# frozen_string_literal: true

module DslBuilder
  class Executor
    def initialize(registry:, out:, working_directory:)
      @registry = registry
      @out = out
      @working_directory = working_directory
    end

    def call(task_name)
      @current_task = task_name
      instance_eval(&registry.fetch(task_name))
    end

    def run(command)
      output, status = Open3.capture2e(command, chdir: working_directory)
      out.print(output)
      raise Error, "command failed: #{command}" unless status.success?
    end

    def method_missing(name, *_args, &)
      raise Error, "unknown task instruction: #{name} in #{current_task}"
    end

    def respond_to_missing?(_name, _include_private = false)
      false
    end

    private

    attr_reader :registry, :out, :working_directory, :current_task
  end
end
