# Helper methods to be added to ActionController::Base.helper
module QueryStats
module Helper
  # Provides access to the QueryStatsHolder
  def queries
    ActiveRecord::Base.connection.queries
  end
end
end
