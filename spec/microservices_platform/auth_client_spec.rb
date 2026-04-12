# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::AuthClient do
  around do |example|
    original = ENV.fetch('AUTH_SERVICE_URL', nil)
    ENV['AUTH_SERVICE_URL'] = 'http://auth.test'
    example.run
    ENV['AUTH_SERVICE_URL'] = original
  end

  it 'fetches a token from the auth service' do
    response = instance_double(Net::HTTPResponse, body: JSON.generate(token: 'token'))

    allow(Net::HTTP).to receive(:post).with(URI('http://auth.test/tokens'), '').and_return(response)

    expect(described_class.new.token).to eq('token')
  end
end
