# frozen_string_literal: true

RSpec.describe DslBuilder::DocumentContext do
  it 'registers tasks from blocks' do
    registry = DslBuilder::TaskRegistry.new

    described_class.new(registry).task('build') { run 'ruby -e "puts :built"' }

    expect(registry.fetch('build')).to be_a(Proc)
  end

  it 'raises for unknown DSL methods' do
    registry = DslBuilder::TaskRegistry.new

    expect do
      described_class.new(registry).deploy('app')
    end.to raise_error(DslBuilder::Error, 'unknown DSL method: deploy')
  end
end
