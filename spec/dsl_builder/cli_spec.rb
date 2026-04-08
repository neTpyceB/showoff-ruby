# frozen_string_literal: true

RSpec.describe DslBuilder::CLI do
  it 'returns success for a valid DSL run' do
    Dir.mktmpdir do |directory|
      dsl_file = File.join(directory, 'tasks.rb')
      File.write(dsl_file, <<~RUBY)
        task 'build' do
          run 'ruby -e "puts :built"'
        end
      RUBY
      out = StringIO.new
      err = StringIO.new

      exit_code = described_class.new(argv: ['run', '--file', dsl_file, '--task', 'build'], out:, err:).call

      expect(exit_code).to eq(0)
      expect(out.string).to include('built')
      expect(err.string).to eq('')
    end
  end

  it 'returns an error for invalid arguments' do
    out = StringIO.new
    err = StringIO.new

    exit_code = described_class.new(argv: ['run', '--file', 'tasks.rb'], out:, err:).call

    expect(exit_code).to eq(1)
    expect(out.string).to eq('')
    expect(err.string).to include('key not found: :task')
  end

  it 'returns an error for an unknown command' do
    out = StringIO.new
    err = StringIO.new

    exit_code = described_class.new(argv: ['deploy'], out:, err:).call

    expect(exit_code).to eq(1)
    expect(out.string).to eq('')
    expect(err.string).to include('usage: run --file FILE --task TASK')
  end
end
