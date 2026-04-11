# frozen_string_literal: true

RSpec.describe RestApiService::Models::Post do
  before do
    RestApiService::Database.connection[:posts].delete
  end

  it 'validates title and body presence' do
    expect do
      described_class.create(title: nil, body: nil)
    end.to raise_error(Sequel::ValidationFailed)
  end

  it 'sets timestamps' do
    api_post = described_class.create(title: 'Hello', body: 'World')

    expect(api_post.created_at).to be_a(Time)
    expect(api_post.updated_at).to be_a(Time)
  end
end
