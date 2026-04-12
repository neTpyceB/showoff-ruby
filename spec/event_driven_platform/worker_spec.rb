# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::Worker do
  it 'processes stream events and stores the offset' do
    bus = instance_double(
      EventDrivenPlatform::Bus,
      read: [['1-0', { 'event' => JSON.generate(message: 'Issue opened') }]]
    )
    processor = instance_double(EventDrivenPlatform::Processor)

    allow(processor).to receive(:call)
    allow(bus).to receive(:ack)

    described_class.new(bus:, processor:).tick

    expect(processor).to have_received(:call).with('1-0', 'message' => 'Issue opened')
    expect(bus).to have_received(:ack).with('1-0')
  end
end
