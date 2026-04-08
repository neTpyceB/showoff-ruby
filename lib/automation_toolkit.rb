# frozen_string_literal: true

require 'logger'
require 'optparse'

require_relative 'automation_toolkit/argument_parser'
require_relative 'automation_toolkit/cli'
require_relative 'automation_toolkit/commands'
require_relative 'automation_toolkit/configuration'
require_relative 'automation_toolkit/directory_entries'
require_relative 'automation_toolkit/logger_factory'
require_relative 'automation_toolkit/runner'

module AutomationToolkit
  class Error < StandardError
  end
end
