# frozen_string_literal: true

RSpec.describe DslBuilder::Executor do
  it 'executes task commands in the DSL file directory' do
    Dir.mktmpdir do |directory|
      registry = DslBuilder::TaskRegistry.new
      registry.add('build', proc { run %(ruby -e "File.write('artifact.txt', 'built')") })
      out = StringIO.new

      described_class.new(registry:, out:, working_directory: directory).call('build')

      expect(File.read(File.join(directory, 'artifact.txt'))).to eq('built')
      expect(out.string).to eq('')
    end
  end

  it 'raises for failing commands' do
    registry = DslBuilder::TaskRegistry.new
    registry.add('build', proc { run %(ruby -e "exit 1") })

    expect do
      described_class.new(registry:, out: StringIO.new, working_directory: Dir.tmpdir).call('build')
    end.to raise_error(DslBuilder::Error, 'command failed: ruby -e "exit 1"')
  end

  it 'raises for unknown task instructions' do
    registry = DslBuilder::TaskRegistry.new
    registry.add('build', proc { deploy 'app' })

    expect do
      described_class.new(registry:, out: StringIO.new, working_directory: Dir.tmpdir).call('build')
    end.to raise_error(DslBuilder::Error, 'unknown task instruction: deploy in build')
  end
end
