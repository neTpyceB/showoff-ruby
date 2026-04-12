# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::Bus do
  before do
    clear_event_driven_platform
  end

  let(:bus) { described_class.new }

  it 'publishes, reads, and acknowledges stream events' do
    event = bus.publish('Issue opened')
    id, fields = bus.read.fetch(0)

    bus.ack(id)

    expect(event).to include('id' => id, 'message' => 'Issue opened', 'attempts' => 0)
    expect(JSON.parse(fields.fetch('event'))).to eq('message' => 'Issue opened', 'attempts' => 0)
    expect(EventDrivenPlatform.redis.get(described_class::OFFSET_KEY)).to eq(id)
    expect(bus.read).to eq([])
  end

  it 'retries once and stores failed events after the retry is exhausted' do
    retried = bus.retry({ 'message' => 'Issue failed', 'attempts' => 0 }, RuntimeError.new('boom'))
    failed = bus.retry({ 'message' => 'Issue failed', 'attempts' => 1 }, RuntimeError.new('boom'))

    expect(retried).to eq('message' => 'Issue failed', 'attempts' => 1, 'error' => 'boom')
    expect(failed).to eq('message' => 'Issue failed', 'attempts' => 2, 'error' => 'boom')
    expect(bus.failed).to eq([failed])
    expect(JSON.parse(bus.read.fetch(0).fetch(1).fetch('event'))).to eq(
      'message' => 'Issue failed',
      'attempts' => 1
    )
  end
end
