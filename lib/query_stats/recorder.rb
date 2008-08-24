# QueryStats::Recorder

module QueryStats
  # Captures query data from ActiveRecord::Base.
  module Recorder
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method_chain :execute, :query_stats
      end
    end
    
    # Returns or initializes the QueryStats::Holder
    def queries
      @query_stats ||= QueryStats::Holder.new
    end
    
    # Executes the query, capturing execution time and logging data to the
    # QueryStats::Holder
    def execute_with_query_stats(*args)
      result = nil
      seconds = Benchmark.realtime do
        result = execute_without_query_stats(*args)
      end
      queries.add(args.first, seconds, *args[1..-1])
      result
    end
  end
end
