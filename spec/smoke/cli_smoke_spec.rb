# frozen_string_literal: true

RSpec.describe 'CLI smoke' do
  it 'runs the packaged executable for search' do
    stdout, stderr, status = Open3.capture3('bundle', 'exec', 'bin/toolkit', 'search', '--path', 'spec/fixtures/smoke',
                                            '--query', 'alpha')

    expect(status.success?).to be(true)
    expect(stdout).to include('spec/fixtures/smoke/alpha.txt')
    expect(stderr).to include('matched spec/fixtures/smoke/alpha.txt')
  end
end
