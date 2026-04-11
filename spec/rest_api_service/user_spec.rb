# frozen_string_literal: true

RSpec.describe RestApiService::Models::User do
  before do
    RestApiService::Database.connection[:users].delete
  end

  it 'hashes and authenticates passwords' do
    user = described_class.create(email: 'user@example.com', password: 'secret')

    expect(user.password_digest).not_to eq('secret')
    expect(user.authenticate?('secret')).to be(true)
  end

  it 'validates unique email' do
    described_class.create(email: 'user@example.com', password: 'secret')

    expect do
      described_class.create(email: 'user@example.com', password: 'secret')
    end.to raise_error(Sequel::ValidationFailed)
  end
end
