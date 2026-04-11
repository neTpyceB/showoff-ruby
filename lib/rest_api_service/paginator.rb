# frozen_string_literal: true

module RestApiService
  module Paginator
    module_function

    def call(dataset:, page:, per_page:)
      {
        items: dataset.limit(per_page, (page - 1) * per_page).all,
        total: dataset.count
      }
    end
  end
end
