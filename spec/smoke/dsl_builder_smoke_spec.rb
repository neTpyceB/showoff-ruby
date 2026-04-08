# frozen_string_literal: true

RSpec.describe 'DSL Builder smoke' do
  it 'runs the packaged executable for a DSL task' do
    stdout, stderr, status = Open3.capture3(
      'bundle',
      'exec',
      'bin/dsl_builder',
      'run',
      '--file',
      'spec/fixtures/dsl/smoke.rb',
      '--task',
      'build'
    )

    expect(status.success?).to be(true)
    expect(stdout).to include('built')
    expect(stderr).to eq('')
  end
end
