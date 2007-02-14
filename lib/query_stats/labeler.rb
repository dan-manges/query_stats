module QueryStats
  module Labeler
    protected
    
    def log_processing_with_query_stats()
      queries.clear
      queries.label = :controller
      log_processing_without_query_stats
    end

    def render_with_query_stats(*args, &block)
      queries.label = :view
      render_without_query_stats(*args, &block)
    end

    # Returns the QueryStatsHolder for the current database connection.
    def queries
      ActiveRecord::Base.connection.queries
    end
    
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method_chain :log_processing, :query_stats
        alias_method_chain :render, :query_stats
      end
    end

  end
end