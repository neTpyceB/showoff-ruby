# frozen_string_literal: true

RSpec.describe EventDrivenPlatform do
  it 'builds the Rack application and worker' do
    expect(described_class.app).to be_a(EventDrivenPlatform::App)
    expect(described_class.redis).to be_a(Redis)
    expect(described_class.worker).to be_a(EventDrivenPlatform::Worker)
  end
end
