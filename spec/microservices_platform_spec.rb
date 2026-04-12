# frozen_string_literal: true

RSpec.describe MicroservicesPlatform do
  it 'builds the service applications' do
    expect(described_class.auth_app).to be_a(MicroservicesPlatform::AuthApp)
    expect(described_class.gateway_app).to be_a(MicroservicesPlatform::GatewayApp)
    expect(described_class.user_app).to be_a(MicroservicesPlatform::UserApp)
    expect(described_class.worker_app).to be_a(MicroservicesPlatform::WorkerApp)
  end
end
