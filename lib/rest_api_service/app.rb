# frozen_string_literal: true

module RestApiService
  class App < Sinatra::Base
    before do
      content_type :json
    end

    post '/api/users' do
      user = Models::User.create(email: payload.fetch('email'), password: payload.fetch('password'))

      status 201
      json(id: user.id, email: user.email)
    rescue Sequel::ValidationFailed => e
      halt 422, json(errors: e.model.errors.full_messages)
    end

    post '/api/session' do
      user = Authenticator.find_user(payload.fetch('email'), payload.fetch('password'))
      halt 401, json(error: 'Unauthorized') unless user

      json(token: Authenticator.issue(user.id))
    end

    before '/api/posts*' do
      halt 401, json(error: 'Unauthorized') unless Authenticator.decode(bearer_token)
    end

    get '/api/posts' do
      page = params.fetch('page', '1').to_i
      per_page = params.fetch('per_page', '10').to_i
      posts = Models::Post.order(:id)
      result = Paginator.call(dataset: posts, page:, per_page:)

      json(
        items: result.fetch(:items).map { |post| Serializers::PostSerializer.call(post) },
        page:,
        per_page:,
        total: result.fetch(:total)
      )
    end

    get '/api/posts/:id' do
      json(Serializers::PostSerializer.call(Models::Post.with_pk!(params.fetch('id'))))
    rescue Sequel::NoMatchingRow
      halt 404, json(error: 'Not Found')
    end

    post '/api/posts' do
      post = Models::Post.create(title: payload.fetch('title'), body: payload.fetch('body'))

      status 201
      json(Serializers::PostSerializer.call(post))
    rescue Sequel::ValidationFailed => e
      halt 422, json(errors: e.model.errors.full_messages)
    end

    patch '/api/posts/:id' do
      post = Models::Post.with_pk!(params.fetch('id'))
      post.update(title: payload.fetch('title'), body: payload.fetch('body'))

      json(Serializers::PostSerializer.call(post))
    rescue Sequel::NoMatchingRow
      halt 404, json(error: 'Not Found')
    rescue Sequel::ValidationFailed => e
      halt 422, json(errors: e.model.errors.full_messages)
    end

    delete '/api/posts/:id' do
      Models::Post.with_pk!(params.fetch('id')).destroy
      status 204
    rescue Sequel::NoMatchingRow
      halt 404, json(error: 'Not Found')
    end

    private

    def payload
      @payload ||= JSON.parse(request.body.read)
    end

    def bearer_token
      request.env.fetch('HTTP_AUTHORIZATION').delete_prefix('Bearer ')
    rescue KeyError
      nil
    end

    def json(object)
      JSON.generate(object)
    end
  end
end
