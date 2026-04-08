# frozen_string_literal: true

RSpec.describe LightweightWebFramework::Response do
  it 'builds a successful text response' do
    response = described_class.ok('hello')

    expect(response.status).to eq(200)
    expect(response.body).to eq('hello')
    expect(response.headers).to eq('Content-Type' => 'text/plain')
  end

  it 'builds a not found response' do
    response = described_class.not_found

    expect(response.status).to eq(404)
    expect(response.body).to eq('Not Found')
    expect(response.headers).to eq('Content-Type' => 'text/plain')
  end
end
