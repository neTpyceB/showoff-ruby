# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  coverage_dir '/tmp/showoff-ruby/coverage'
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
end

require 'tmpdir'
require 'open3'
require 'stringio'
require 'net/http'
require 'json'
require 'rack/test'
require 'socket'
require 'websocket-client-simple'

ENV['APP_ENV'] ||= 'test'
ENV['JWT_SECRET'] ||= 'test-secret'
ENV['DATABASE_URL'] ||= 'postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development'

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'automation_toolkit'
require 'dsl_builder'
require 'lightweight_web_framework'
require 'realtime_collaboration'
require 'rest_api_service'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '/tmp/showoff-ruby/rspec_status'
  config.order = :random
  Kernel.srand config.seed
end
