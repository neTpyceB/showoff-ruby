# frozen_string_literal: true

module RealtimeCollaboration
  class CollaborationChannel < ActionCable::Channel::Base
    def subscribed
      stream_from STREAM
      transmit({ type: 'state', state: State.snapshot })
    end

    def update(data)
      state = State.update(data.fetch('content'))
      ActionCable.server.broadcast(STREAM, { type: 'state', state: })
      ActionCable.server.broadcast(STREAM, { type: 'notification', message: 'Document updated' })
    end
  end
end
