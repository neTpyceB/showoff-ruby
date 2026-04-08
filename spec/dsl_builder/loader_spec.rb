# frozen_string_literal: true

RSpec.describe DslBuilder::Loader do
  it 'loads tasks from a DSL file' do
    Dir.mktmpdir do |directory|
      file = File.join(directory, 'tasks.rb')
      File.write(file, <<~RUBY)
        task 'build' do
          run 'ruby -e "puts :built"'
        end
      RUBY

      registry = described_class.new.call(file)

      expect(registry.fetch('build')).to be_a(Proc)
    end
  end

  it 'raises for unknown top-level DSL methods' do
    Dir.mktmpdir do |directory|
      file = File.join(directory, 'tasks.rb')
      File.write(file, "deploy 'app'\n")

      expect do
        described_class.new.call(file)
      end.to raise_error(DslBuilder::Error, 'unknown DSL method: deploy')
    end
  end
end
