__END__
# This module should be included in ApplicationController to automatically label
# queries as if they are executed before or after rendering starts.  The labels applied
# will be <tt>:controller</tt> or <tt>:view</tt>
module QueryStats
  def self.append_features(base) #:nodoc:
    base.class_eval do
      include InstanceMethods
      alias_method :log_processing_without_query_stats, :log_processing
      alias_method :log_processing, :log_processing_with_query_stats
      alias_method :render_without_query_stats, :render
      alias_method :render, :render_with_query_stats
    end
  end
  
  module InstanceMethods #:nodoc:
    
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
  end

end