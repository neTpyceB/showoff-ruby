# frozen_string_literal: true

RSpec.describe AutomationToolkit::Runner do
  it 'prints command results to stdout' do
    Dir.mktmpdir do |directory|
      target = File.join(directory, 'alpha.txt')
      File.write(target, 'alpha')
      out = StringIO.new
      err = StringIO.new
      configuration = AutomationToolkit::Configuration.new(
        command: :search,
        path: directory,
        query: 'alpha',
        name: nil,
        log_level: Logger::INFO
      )

      described_class.new(configuration:, out:, err:).call

      expect(out.string).to eq("#{target}\n")
      expect(err.string).to include("matched #{target}")
    end
  end

  it 'dispatches rename results to stdout' do
    Dir.mktmpdir do |directory|
      source = File.join(directory, 'alpha.txt')
      File.write(source, 'alpha')
      out = StringIO.new
      err = StringIO.new
      configuration = AutomationToolkit::Configuration.new(
        command: :rename,
        path: source,
        query: nil,
        name: 'beta.txt',
        log_level: Logger::INFO
      )

      described_class.new(configuration:, out:, err:).call

      expect(out.string).to eq("#{File.join(directory, 'beta.txt')}\n")
      expect(err.string).to include('renamed')
    end
  end

  it 'dispatches organize results to stdout' do
    Dir.mktmpdir do |directory|
      source = File.join(directory, 'alpha.txt')
      File.write(source, 'alpha')
      out = StringIO.new
      err = StringIO.new
      configuration = AutomationToolkit::Configuration.new(
        command: :organize,
        path: directory,
        query: nil,
        name: nil,
        log_level: Logger::INFO
      )

      described_class.new(configuration:, out:, err:).call

      expect(out.string).to eq("#{File.join(directory, 'txt', 'alpha.txt')}\n")
      expect(err.string).to include('organized')
    end
  end
end
