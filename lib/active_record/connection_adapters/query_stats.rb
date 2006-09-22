# Module to add to ActiveRecord::Base.connection to track queries.

module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    module QueryStats #:nodoc:
      QUERY_METHODS = [:begin_db_transaction,
                       :columns,
                       :commit_db_transaction,
                       :delete,
                       :insert,
                       :rollback_db_transaction,
                       :select_all,
                       :select_one,
                       :select_value,
                       :select_values,
                       :update]
      def self.append_features(base)
        super
        base.class_eval do
          QUERY_METHODS.each do |method|
            define_method("#{method}_with_query_stats") do |*args|
              queries.query_type = method unless queries.query_type == :columns
              send "#{method}_without_query_stats", *args
            end
            alias_method "#{method}_without_query_stats", method
            alias_method method, "#{method}_with_query_stats"
          end
          alias_method :execute_without_query_stats, :execute
          alias_method :execute, :execute_with_query_stats
        end
      end
      
      def queries
        @query_stats ||= QueryStatsHolder.new
      end
      
      def execute_with_query_stats(*args)
        result = nil
        seconds =
          Benchmark.realtime do
            result = execute_without_query_stats(*args)
          end
        queries.add(seconds, *args)
        queries.query_type = nil
        result
      end
    end
  end
end