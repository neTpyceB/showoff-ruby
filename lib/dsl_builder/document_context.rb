# frozen_string_literal: true

module DslBuilder
  class DocumentContext
    def initialize(registry)
      @registry = registry
    end

    def task(name, &block)
      registry.add(name, block)
    end

    def method_missing(name, *_args, &)
      raise Error, "unknown DSL method: #{name}"
    end

    def respond_to_missing?(_name, _include_private = false)
      false
    end

    private

    attr_reader :registry
  end
end
