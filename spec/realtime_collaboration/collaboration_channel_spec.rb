# frozen_string_literal: true

RSpec.describe RealtimeCollaboration::CollaborationChannel do
  before do
    RealtimeCollaboration::State.reset!
  end

  it 'streams the current shared state on subscribe' do
    channel = described_class.allocate
    allow(channel).to receive(:stream_from)
    allow(channel).to receive(:transmit)

    channel.subscribed

    expect(channel).to have_received(:stream_from).with(RealtimeCollaboration::STREAM)
    expect(channel).to have_received(:transmit).with({ type: 'state', state: { 'content' => '', 'version' => 0 } })
  end

  it 'broadcasts shared state and notifications on update' do
    channel = described_class.allocate
    allow(ActionCable.server).to receive(:broadcast)

    channel.update('content' => 'Hello')

    expect(ActionCable.server).to have_received(:broadcast)
      .with(RealtimeCollaboration::STREAM, { type: 'state', state: { 'content' => 'Hello', 'version' => 1 } })
    expect(ActionCable.server).to have_received(:broadcast)
      .with(RealtimeCollaboration::STREAM, { type: 'notification', message: 'Document updated' })
  end
end
