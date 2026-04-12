# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::UserClient do
  around do |example|
    original = ENV.fetch('USER_SERVICE_URL', nil)
    ENV['USER_SERVICE_URL'] = 'http://user.test'
    example.run
    ENV['USER_SERVICE_URL'] = original
  end

  it 'fetches a user with a bearer token' do
    http = instance_double(Net::HTTP)
    response = instance_double(Net::HTTPResponse, body: JSON.generate(id: '1', name: 'User 1'))

    allow(Net::HTTP).to receive(:start).with('user.test', 80).and_yield(http)
    allow(http).to receive(:request).and_return(response)

    expect(described_class.new.fetch('1', 'token')).to eq('id' => '1', 'name' => 'User 1')
  end
end
