# frozen_string_literal: true

require 'concurrent/timer_task'
require 'action_cable'
require 'json'
require 'logger'
require 'rack'

require_relative 'realtime_collaboration/app'
require_relative 'realtime_collaboration/collaboration_channel'
require_relative 'realtime_collaboration/state'

module RealtimeCollaboration
  STREAM = 'collaboration'

  def self.app
    configure_cable

    Rack::Builder.new do
      map('/cable') { run ActionCable.server }
      map('/') { run App.new }
    end
  end

  def self.configure_cable
    ActionCable.server.config.cable = { 'adapter' => 'async' }
    ActionCable.server.config.logger = Logger.new($stdout)
    ActionCable.server.config.allowed_request_origins = [
      %r{\Ahttp://127\.0\.0\.1:\d+\z},
      %r{\Ahttp://localhost:\d+\z}
    ]
  end
end
