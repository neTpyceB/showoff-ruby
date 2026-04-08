# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
end

require 'tmpdir'
require 'open3'
require 'stringio'

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'automation_toolkit'
require 'dsl_builder'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '.rspec_status'
  config.order = :random
  Kernel.srand config.seed
end
