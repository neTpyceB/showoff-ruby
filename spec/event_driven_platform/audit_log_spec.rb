# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::AuditLog do
  before do
    clear_event_driven_platform
  end

  it 'stores audit records' do
    described_class.new.call('1-0', 'message' => 'Issue opened', 'attempts' => 0)

    expect(described_class.all).to eq(
      [{ 'event_id' => '1-0', 'message' => 'Issue opened', 'attempts' => 0 }]
    )
  end
end
