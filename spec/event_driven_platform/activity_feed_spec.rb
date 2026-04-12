# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::ActivityFeed do
  before do
    clear_event_driven_platform
  end

  it 'stores activity feed records' do
    described_class.new.call('1-0', 'message' => 'Issue opened')

    expect(described_class.all).to eq([{ 'event_id' => '1-0', 'message' => 'Activity: Issue opened' }])
  end
end
