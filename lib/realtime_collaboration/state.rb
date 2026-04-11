# frozen_string_literal: true

module RealtimeCollaboration
  module State
    @content = ''
    @version = 0
    @mutex = Mutex.new

    def self.snapshot
      @mutex.synchronize { { 'content' => @content, 'version' => @version } }
    end

    def self.update(content)
      @mutex.synchronize do
        @content = content
        @version += 1
        { 'content' => @content, 'version' => @version }
      end
    end

    def self.reset!
      @mutex.synchronize do
        @content = ''
        @version = 0
      end
    end
  end
end
