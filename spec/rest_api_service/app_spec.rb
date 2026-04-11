# frozen_string_literal: true

RSpec.describe RestApiService::App do
  include Rack::Test::Methods

  def app
    described_class
  end

  def json_body
    JSON.parse(last_response.body)
  end

  def auth_header
    token = RestApiService::Authenticator.issue(create_user.id)
    { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
  end

  def create_user(email: 'user@example.com', password: 'secret')
    RestApiService::Models::User.create(email:, password:)
  end

  before do
    RestApiService::Database.connection[:posts].delete
    RestApiService::Database.connection[:users].delete
  end

  it 'creates a user' do
    post '/api/users', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(201)
    expect(json_body).to include('email' => 'user@example.com')
  end

  it 'validates user creation' do
    create_user

    post '/api/users', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(422)
    expect(json_body.fetch('errors')).to include('email is already taken')
  end

  it 'issues a jwt token for a valid login' do
    create_user

    post '/api/session', JSON.generate({ email: 'user@example.com', password: 'secret' }),
         'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(200)
    expect(RestApiService::Authenticator.decode(json_body.fetch('token'))).to include('user_id')
  end

  it 'rejects an invalid login' do
    create_user

    post '/api/session', JSON.generate({ email: 'user@example.com', password: 'wrong' }),
         'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(401)
    expect(json_body).to eq('error' => 'Unauthorized')
  end

  it 'requires auth for listing posts' do
    get '/api/posts'

    expect(last_response.status).to eq(401)
    expect(json_body).to eq('error' => 'Unauthorized')
  end

  it 'creates a post' do
    post '/api/posts', JSON.generate({ title: 'Hello', body: 'World' }),
         auth_header.merge('CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq(201)
    expect(json_body).to include('title' => 'Hello', 'body' => 'World')
  end

  it 'validates post creation' do
    post '/api/posts', JSON.generate({ title: nil, body: nil }), auth_header.merge('CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq(422)
    expect(json_body.fetch('errors')).to include('title is not present', 'body is not present')
  end

  it 'lists paginated posts' do
    RestApiService::Models::Post.create(title: 'One', body: 'Body 1')
    RestApiService::Models::Post.create(title: 'Two', body: 'Body 2')

    get '/api/posts?page=2&per_page=1', {}, auth_header

    expect(last_response.status).to eq(200)
    expect(json_body).to include('page' => 2, 'per_page' => 1, 'total' => 2)
    expect(json_body.fetch('items').first.fetch('title')).to eq('Two')
  end

  it 'shows one post' do
    api_post = RestApiService::Models::Post.create(title: 'Hello', body: 'World')

    get "/api/posts/#{api_post.id}", {}, auth_header

    expect(last_response.status).to eq(200)
    expect(json_body.fetch('id')).to eq(api_post.id)
  end

  it 'returns not found for a missing post' do
    get '/api/posts/999', {}, auth_header

    expect(last_response.status).to eq(404)
    expect(json_body).to eq('error' => 'Not Found')
  end

  it 'updates a post' do
    api_post = RestApiService::Models::Post.create(title: 'Hello', body: 'World')

    patch "/api/posts/#{api_post.id}", JSON.generate({ title: 'Updated', body: 'Text' }),
          auth_header.merge('CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq(200)
    expect(json_body).to include('title' => 'Updated', 'body' => 'Text')
  end

  it 'validates post update' do
    api_post = RestApiService::Models::Post.create(title: 'Hello', body: 'World')

    patch "/api/posts/#{api_post.id}", JSON.generate({ title: nil, body: nil }),
          auth_header.merge('CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq(422)
    expect(json_body.fetch('errors')).to include('title is not present', 'body is not present')
  end

  it 'returns not found for updating a missing post' do
    patch '/api/posts/999', JSON.generate({ title: 'Updated', body: 'Text' }),
          auth_header.merge('CONTENT_TYPE' => 'application/json')

    expect(last_response.status).to eq(404)
    expect(json_body).to eq('error' => 'Not Found')
  end

  it 'deletes a post' do
    api_post = RestApiService::Models::Post.create(title: 'Hello', body: 'World')

    delete "/api/posts/#{api_post.id}", {}, auth_header

    expect(last_response.status).to eq(204)
    expect(RestApiService::Models::Post[api_post.id]).to be_nil
  end

  it 'returns not found for deleting a missing post' do
    delete '/api/posts/999', {}, auth_header

    expect(last_response.status).to eq(404)
    expect(json_body).to eq('error' => 'Not Found')
  end
end
