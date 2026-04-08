# frozen_string_literal: true

RSpec.describe AutomationToolkit::LoggerFactory do
  it 'formats log messages' do
    io = StringIO.new
    logger = described_class.build(level: Logger::INFO, io:)

    logger.info('hello')

    expect(io.string).to eq("[INFO] hello\n")
  end
end
