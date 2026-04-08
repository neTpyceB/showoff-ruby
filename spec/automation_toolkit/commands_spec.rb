# frozen_string_literal: true

RSpec.describe AutomationToolkit::Commands::Search do
  it 'returns direct child matches and logs them' do
    Dir.mktmpdir do |directory|
      File.write(File.join(directory, 'alpha.txt'), 'alpha')
      File.write(File.join(directory, 'beta.txt'), 'beta')
      Dir.mkdir(File.join(directory, 'nested'))
      File.write(File.join(directory, 'nested', 'alpha.txt'), 'nested')
      log = StringIO.new
      logger = AutomationToolkit::LoggerFactory.build(level: Logger::INFO, io: log)

      result = described_class.new(path: directory, query: 'alpha', logger:).call

      expect(result).to eq([File.join(directory, 'alpha.txt')])
      expect(log.string).to include("matched #{File.join(directory, 'alpha.txt')}")
    end
  end
end

RSpec.describe AutomationToolkit::Commands::Rename do
  it 'renames a file and returns the new path' do
    Dir.mktmpdir do |directory|
      source = File.join(directory, 'before.txt')
      target = File.join(directory, 'after.txt')
      File.write(source, 'payload')
      logger = AutomationToolkit::LoggerFactory.build(level: Logger::INFO, io: StringIO.new)

      result = described_class.new(path: source, name: 'after.txt', logger:).call

      expect(result).to eq([target])
      expect(File.exist?(source)).to be(false)
      expect(File.read(target)).to eq('payload')
    end
  end
end

RSpec.describe AutomationToolkit::Commands::Organize do
  it 'moves direct child files into extension folders and skips files without extensions' do
    Dir.mktmpdir do |directory|
      ruby_file = File.join(directory, 'script.rb')
      plain_file = File.join(directory, 'README')
      nested_directory = File.join(directory, 'nested')
      File.write(ruby_file, 'puts :ok')
      File.write(plain_file, 'plain')
      Dir.mkdir(nested_directory)
      File.write(File.join(nested_directory, 'note.txt'), 'nested')
      logger = AutomationToolkit::LoggerFactory.build(level: Logger::INFO, io: StringIO.new)

      result = described_class.new(path: directory, logger:).call

      expect(result).to eq([File.join(directory, 'rb', 'script.rb')])
      expect(File.exist?(File.join(directory, 'rb', 'script.rb'))).to be(true)
      expect(File.exist?(plain_file)).to be(true)
      expect(File.exist?(File.join(nested_directory, 'note.txt'))).to be(true)
    end
  end
end
