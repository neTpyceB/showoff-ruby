# frozen_string_literal: true

RSpec.describe 'REST API flow' do
  include Rack::Test::Methods

  def app
    RestApiService::App
  end

  before do
    RestApiService::Database.connection[:posts].delete
    RestApiService::Database.connection[:users].delete
  end

  it 'creates a user, logs in, and performs full post crud' do
    post '/api/users', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'
    post '/api/session', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'
    token = JSON.parse(last_response.body).fetch('token')

    post '/api/posts', JSON.generate({ title: 'Hello', body: 'World' }),
         'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{token}"
    created = JSON.parse(last_response.body)

    get '/api/posts?page=1&per_page=10', {}, 'HTTP_AUTHORIZATION' => "Bearer #{token}"
    patch "/api/posts/#{created.fetch('id')}", JSON.generate({ title: 'Updated', body: 'Text' }),
          'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{token}"
    get "/api/posts/#{created.fetch('id')}", {}, 'HTTP_AUTHORIZATION' => "Bearer #{token}"
    delete "/api/posts/#{created.fetch('id')}", {}, 'HTTP_AUTHORIZATION' => "Bearer #{token}"

    expect(last_response.status).to eq(204)
    expect(RestApiService::Models::Post[created.fetch('id')]).to be_nil
  end
end
