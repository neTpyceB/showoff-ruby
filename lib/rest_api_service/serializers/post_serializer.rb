# frozen_string_literal: true

module RestApiService
  module Serializers
    module PostSerializer
      module_function

      def call(post)
        {
          id: post.id,
          title: post.title,
          body: post.body,
          created_at: post.created_at.iso8601,
          updated_at: post.updated_at.iso8601
        }
      end
    end
  end
end
