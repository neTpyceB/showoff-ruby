# frozen_string_literal: true

RSpec.describe AutomationToolkit::DirectoryEntries do
  it 'returns an enumerator when no block is given' do
    expect(described_class.each_file('tmp')).to be_an(Enumerator)
  end

  it 'yields direct child files only' do
    Dir.mktmpdir do |directory|
      File.write(File.join(directory, 'alpha.txt'), 'alpha')
      Dir.mkdir(File.join(directory, 'nested'))
      File.write(File.join(directory, 'nested', 'beta.txt'), 'beta')

      files = []
      described_class.each_file(directory) { files << it }

      expect(files).to eq([File.join(directory, 'alpha.txt')])
    end
  end
end
