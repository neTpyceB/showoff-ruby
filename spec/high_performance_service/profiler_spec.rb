# frozen_string_literal: true

RSpec.describe HighPerformanceService::Profiler do
  it 'returns CPU, allocation, and memory metrics' do
    profile = described_class.call { HighPerformanceService::Calculator.fibonacci(10) }

    expect(profile.fetch(:cpu_ns)).to be >= 0
    expect(profile.fetch(:allocated_objects)).to be >= 0
    expect(profile).to have_key(:memory_bytes)
  end
end
