# frozen_string_literal: true

RSpec.describe EventDrivenPlatform::App do
  before do
    clear_event_driven_platform
  end

  let(:bus) { EventDrivenPlatform::Bus.new }
  let(:request) { Rack::MockRequest.new(described_class.new(bus:)) }

  it 'serves the browser page' do
    response = request.get('/')

    expect(response.status).to eq(200)
    expect(response.body).to include('Event-driven platform', '/events')
  end

  it 'publishes events and returns projected read models' do
    event = JSON.parse(request.post('/events', input: JSON.generate(message: 'Issue opened')).body)

    EventDrivenPlatform.worker.tick

    expect(event).to include('id', 'message' => 'Issue opened', 'attempts' => 0)
    expect(JSON.parse(request.get('/notifications').body)).to eq(
      [{ 'event_id' => event.fetch('id'), 'message' => 'Notification: Issue opened' }]
    )
    expect(JSON.parse(request.get('/activity').body)).to eq(
      [{ 'event_id' => event.fetch('id'), 'message' => 'Activity: Issue opened' }]
    )
    expect(JSON.parse(request.get('/audit').body)).to eq(
      [{ 'event_id' => event.fetch('id'), 'message' => 'Issue opened', 'attempts' => 0 }]
    )
  end

  it 'returns not found for unsupported requests' do
    expect(request.get('/missing').status).to eq(404)
    expect(request.post('/notifications').status).to eq(404)
  end
end
