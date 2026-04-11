# frozen_string_literal: true

RSpec.describe RealtimeCollaboration do
  it 'builds the Rack application with ActionCable configured' do
    app = described_class.app

    response = Rack::MockRequest.new(app).get('/')

    expect(response.status).to eq(200)
    expect(ActionCable.server.config.cable).to eq('adapter' => 'async')
  end
end
