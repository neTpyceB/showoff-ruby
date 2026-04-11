# frozen_string_literal: true

RSpec.describe RestApiService::Database do
  it 'returns the current sequel connection' do
    expect(described_class.connection).to be_a(Sequel::Database)
  end

  it 'connects from an explicit url' do
    expect(described_class.connect(ENV.fetch('DATABASE_URL'))).to be_a(Sequel::Database)
  end
end
