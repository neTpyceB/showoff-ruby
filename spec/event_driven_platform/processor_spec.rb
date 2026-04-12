# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::Processor do
  it 'passes events to every handler' do
    calls = []
    handler = ->(id, event) { calls << [id, event] }

    described_class.new(bus: instance_double(EventDrivenPlatform::Bus), handlers: [handler]).call(
      '1-0',
      'message' => 'Issue opened'
    )

    expect(calls).to eq([['1-0', { 'message' => 'Issue opened' }]])
  end

  it 'retries handler failures' do
    bus = instance_double(EventDrivenPlatform::Bus)
    event = { 'message' => 'Issue failed', 'attempts' => 0 }

    allow(bus).to receive(:retry)

    described_class.new(bus:, handlers: [->(_id, _event) { raise 'boom' }]).call('1-0', event)

    expect(bus).to have_received(:retry).with(event, instance_of(RuntimeError))
  end
end
