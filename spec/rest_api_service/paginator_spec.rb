# frozen_string_literal: true

RSpec.describe RestApiService::Paginator do
  before do
    RestApiService::Database.connection[:posts].delete
  end

  it 'returns a page of results and total count' do
    RestApiService::Models::Post.create(title: 'One', body: 'Body 1')
    RestApiService::Models::Post.create(title: 'Two', body: 'Body 2')

    result = described_class.call(dataset: RestApiService::Models::Post.order(:id), page: 2, per_page: 1)

    expect(result.fetch(:total)).to eq(2)
    expect(result.fetch(:items).map(&:title)).to eq(['Two'])
  end
end
