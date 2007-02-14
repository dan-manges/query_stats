module QueryStats
  module Logger
    protected
    def active_record_runtime_with_query_stats(*args, &block)
      active_record_runtime_without_query_stats(*args, &block) << " #{ActiveRecord::Base.connection.queries.count} queries"
    end
  
    def self.included(base)
      base.class_eval do
        alias_method_chain :active_record_runtime, :query_stats
      end
    end
  end
end
