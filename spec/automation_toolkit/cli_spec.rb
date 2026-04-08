# frozen_string_literal: true

RSpec.describe AutomationToolkit::CLI do
  it 'returns a success code for valid arguments' do
    Dir.mktmpdir do |directory|
      target = File.join(directory, 'alpha.txt')
      File.write(target, 'alpha')
      out = StringIO.new
      err = StringIO.new

      exit_code = described_class.new(argv: ['search', '--path', directory, '--query', 'alpha'], out:, err:).call

      expect(exit_code).to eq(0)
      expect(out.string).to eq("#{target}\n")
      expect(err.string).to include("matched #{target}")
    end
  end

  it 'returns an error code for invalid arguments' do
    out = StringIO.new
    err = StringIO.new

    exit_code = described_class.new(argv: ['search', '--path', 'tmp'], out:, err:).call

    expect(exit_code).to eq(1)
    expect(out.string).to eq('')
    expect(err.string).to include('key not found: :query')
  end
end
