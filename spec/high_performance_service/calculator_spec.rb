# frozen_string_literal: true

RSpec.describe HighPerformanceService::Calculator do
  it 'calculates fibonacci numbers without recursive allocation pressure' do
    expect(described_class.fibonacci(0)).to eq(0)
    expect(described_class.fibonacci(1)).to eq(1)
    expect(described_class.fibonacci(10)).to eq(55)
    expect(described_class.fibonacci(35)).to eq(9_227_465)
  end
end
