# frozen_string_literal: true

module AutomationToolkit
  Configuration = Data.define(:command, :path, :query, :name, :log_level)
end
