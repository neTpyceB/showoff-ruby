# frozen_string_literal: true

require 'fileutils'

module AutomationToolkit
  module Commands
    class Search
      def initialize(path:, query:, logger:)
        @path = path
        @query = query
        @logger = logger
      end

      def call
        DirectoryEntries.each_file(path).select do |file|
          next false unless File.basename(file).include?(query)

          logger.info("matched #{file}")
          true
        end
      end

      private

      attr_reader :path, :query, :logger
    end

    class Rename
      def initialize(path:, name:, logger:)
        @path = path
        @name = name
        @logger = logger
      end

      def call
        target = File.join(File.dirname(path), name)
        File.rename(path, target)
        logger.info("renamed #{path} -> #{target}")
        [target]
      end

      private

      attr_reader :path, :name, :logger
    end

    class Organize
      def initialize(path:, logger:)
        @path = path
        @logger = logger
      end

      def call
        DirectoryEntries.each_file(path).with_object([]) do |file, moves|
          extension = File.extname(file).delete_prefix('.')
          next if extension.empty?

          directory = File.join(path, extension)
          target = File.join(directory, File.basename(file))
          FileUtils.mkdir_p(directory)
          File.rename(file, target)
          logger.info("organized #{file} -> #{target}")
          moves << target
        end
      end

      private

      attr_reader :path, :logger
    end
  end
end
