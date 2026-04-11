# frozen_string_literal: true

RSpec.describe RestApiService::Authenticator do
  before do
    RestApiService::Database.connection[:users].delete
  end

  it 'encodes and decodes a token' do
    token = described_class.issue(1)

    expect(described_class.decode(token)).to include('user_id' => 1)
  end

  it 'returns nil for an invalid token' do
    expect(described_class.decode('invalid')).to be_nil
  end

  it 'finds a user by valid credentials' do
    user = RestApiService::Models::User.create(email: 'user@example.com', password: 'secret')

    expect(described_class.find_user('user@example.com', 'secret')).to eq(user)
  end

  it 'returns nil for unknown credentials' do
    expect(described_class.find_user('user@example.com', 'secret')).to be_nil
  end
end
