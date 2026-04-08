# frozen_string_literal: true

module DslBuilder
  class TaskRegistry
    def initialize
      @tasks = {}
    end

    def add(name, block)
      tasks[name] = block
    end

    def fetch(name)
      tasks.fetch(name) { raise Error, "unknown task: #{name}" }
    end

    private

    attr_reader :tasks
  end
end
