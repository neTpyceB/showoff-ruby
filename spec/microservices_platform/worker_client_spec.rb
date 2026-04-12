# frozen_string_literal: true

RSpec.describe MicroservicesPlatform::WorkerClient do
  around do |example|
    original = ENV.fetch('WORKER_SERVICE_URL', nil)
    ENV['WORKER_SERVICE_URL'] = 'http://worker.test'
    example.run
    ENV['WORKER_SERVICE_URL'] = original
  end

  it 'posts a worker job' do
    response = instance_double(Net::HTTPResponse, body: JSON.generate(user_id: '1', status: 'processed'))

    allow(Net::HTTP).to receive(:post).with(
      URI('http://worker.test/jobs'),
      JSON.generate(user_id: '1'),
      'Content-Type' => 'application/json'
    ).and_return(response)

    expect(described_class.new.process('1')).to eq('user_id' => '1', 'status' => 'processed')
  end
end
