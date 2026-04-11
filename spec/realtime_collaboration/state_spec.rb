# frozen_string_literal: true

RSpec.describe RealtimeCollaboration::State do
  before do
    described_class.reset!
  end

  it 'stores shared content with a version' do
    expect(described_class.snapshot).to eq('content' => '', 'version' => 0)
    expect(described_class.update('Hello')).to eq('content' => 'Hello', 'version' => 1)
    expect(described_class.snapshot).to eq('content' => 'Hello', 'version' => 1)
  end
end
