# frozen_string_literal: true

module AutomationToolkit
  module DirectoryEntries
    module_function

    def each_file(path)
      return enum_for(__method__, path) unless block_given?

      Dir.each_child(path) do |entry|
        file = File.join(path, entry)
        yield file if File.file?(file)
      end
    end
  end
end
