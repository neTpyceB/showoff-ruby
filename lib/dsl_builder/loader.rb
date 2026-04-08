# frozen_string_literal: true

module DslBuilder
  class Loader
    def call(path)
      registry = TaskRegistry.new
      DocumentContext.new(registry).instance_eval(File.read(path), path)
      registry
    end
  end
end
