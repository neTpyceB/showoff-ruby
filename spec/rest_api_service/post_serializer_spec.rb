# frozen_string_literal: true

RSpec.describe RestApiService::Serializers::PostSerializer do
  before do
    RestApiService::Database.connection[:posts].delete
  end

  it 'serializes a post' do
    api_post = RestApiService::Models::Post.create(title: 'Hello', body: 'World')

    result = described_class.call(api_post)

    expect(result).to include(:id, :title, :body, :created_at, :updated_at)
    expect(result.fetch(:title)).to eq('Hello')
  end
end
