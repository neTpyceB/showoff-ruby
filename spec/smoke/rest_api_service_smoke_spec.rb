# frozen_string_literal: true

RSpec.describe 'REST API smoke' do
  include Rack::Test::Methods

  def app
    RestApiService::App
  end

  before do
    RestApiService::Database.connection[:posts].delete
    RestApiService::Database.connection[:users].delete
  end

  it 'serves the core api flow' do
    post '/api/users', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'
    post '/api/session', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'
    token = JSON.parse(last_response.body).fetch('token')
    get '/api/posts?page=1&per_page=10', {}, 'HTTP_AUTHORIZATION' => "Bearer #{token}"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to include('items' => [], 'page' => 1, 'per_page' => 10, 'total' => 0)
  end
end
