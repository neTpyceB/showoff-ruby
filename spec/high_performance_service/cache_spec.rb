# frozen_string_literal: true

RSpec.describe HighPerformanceService::Cache do
  before do
    described_class.redis.flushdb
  end

  it 'caches calculator results in Redis' do
    expect(described_class.fetch(10)).to eq([55, false])
    expect(described_class.fetch(10)).to eq([55, true])
  end
end
