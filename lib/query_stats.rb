# This module should be included in ApplicationController to automatically label
# queries as if they are executed before or after rendering starts.  The labels applied
# will be <tt>:controller</tt> or <tt>:view</tt>
module QueryStats
  def self.append_features(base) #:nodoc:
    base.class_eval do
      include InstanceMethods
      alias_method :process_without_query_stats, :process
      alias_method :process, :process_with_query_stats
      alias_method :render_without_query_stats, :render
      alias_method :render, :render_with_query_stats
    end
  end
  
  module InstanceMethods #:nodoc:
    def process_with_query_stats(*args, &block)
      queries.clear
      queries.label = :controller
      process_without_query_stats(*args, &block)
    end
    
    protected
    
      def render_with_query_stats(*args, &block)
        queries.label = :view
        render_without_query_stats(*args, &block)
      end
    
      # Returns the QueryStatsHolder for the current database connection.
      def queries
        ActiveRecord::Base.connection.queries
      end
  end

end