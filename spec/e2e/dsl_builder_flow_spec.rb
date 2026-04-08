# frozen_string_literal: true

RSpec.describe 'DSL Builder flow' do
  it 'loads and executes a build task end to end' do
    Dir.mktmpdir do |directory|
      dsl_file = File.join(directory, 'tasks.rb')
      artifact = File.join(directory, 'artifact.txt')
      File.write(dsl_file, <<~RUBY)
        task 'build' do
          run %(ruby -e "File.write('artifact.txt', 'built')")
        end
      RUBY

      stdout, stderr, status = Open3.capture3('bundle', 'exec', 'bin/dsl_builder', 'run', '--file', dsl_file, '--task',
                                              'build')

      expect(status.success?).to be(true)
      expect(stdout).to eq('')
      expect(stderr).to eq('')
      expect(File.read(artifact)).to eq('built')
    end
  end
end
