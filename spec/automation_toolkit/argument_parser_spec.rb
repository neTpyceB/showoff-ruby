# frozen_string_literal: true

RSpec.describe AutomationToolkit::ArgumentParser do
  it 'parses search arguments' do
    configuration = described_class.new(['search', '--path', 'tmp', '--query', 'alpha', '--log-level', 'debug']).call

    expect(configuration).to eq(
      AutomationToolkit::Configuration.new(
        command: :search,
        path: 'tmp',
        query: 'alpha',
        name: nil,
        log_level: Logger::DEBUG
      )
    )
  end

  it 'parses rename arguments' do
    configuration = described_class.new(['rename', '--path', 'tmp/file.txt', '--name', 'renamed.txt']).call

    expect(configuration.command).to eq(:rename)
    expect(configuration.path).to eq('tmp/file.txt')
    expect(configuration.name).to eq('renamed.txt')
  end

  it 'parses organize arguments' do
    configuration = described_class.new(['organize', '--path', 'tmp']).call

    expect(configuration.command).to eq(:organize)
    expect(configuration.path).to eq('tmp')
    expect(configuration.log_level).to eq(Logger::INFO)
  end

  it 'raises for an unknown command' do
    expect do
      described_class.new(['unknown']).call
    end.to raise_error(AutomationToolkit::Error, 'commands: search, rename, organize')
  end
end
