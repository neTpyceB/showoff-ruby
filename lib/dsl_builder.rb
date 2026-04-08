# frozen_string_literal: true

require 'open3'
require 'optparse'

require_relative 'dsl_builder/cli'
require_relative 'dsl_builder/configuration'
require_relative 'dsl_builder/document_context'
require_relative 'dsl_builder/executor'
require_relative 'dsl_builder/loader'
require_relative 'dsl_builder/task_registry'

module DslBuilder
  class Error < StandardError
  end
end
