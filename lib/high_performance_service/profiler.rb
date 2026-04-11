# frozen_string_literal: true

module HighPerformanceService
  module Profiler
    def self.call
      cpu = Process.clock_gettime(Process::CLOCK_THREAD_CPUTIME_ID, :nanosecond)
      objects = GC.stat.fetch(:total_allocated_objects)
      memory = ObjectSpace.memsize_of_all

      yield

      {
        cpu_ns: Process.clock_gettime(Process::CLOCK_THREAD_CPUTIME_ID, :nanosecond) - cpu,
        allocated_objects: GC.stat.fetch(:total_allocated_objects) - objects,
        memory_bytes: ObjectSpace.memsize_of_all - memory
      }
    end
  end
end
