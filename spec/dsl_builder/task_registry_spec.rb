# frozen_string_literal: true

RSpec.describe DslBuilder::TaskRegistry do
  it 'stores and fetches tasks' do
    block = proc { run 'ruby -e "puts :built"' }
    registry = described_class.new

    registry.add('build', block)

    expect(registry.fetch('build')).to eq(block)
  end

  it 'raises for unknown tasks' do
    expect do
      described_class.new.fetch('build')
    end.to raise_error(DslBuilder::Error, 'unknown task: build')
  end
end
