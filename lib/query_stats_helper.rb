# Helper methods to be added to ActionController::Base.helper
module QueryStatsHelper
  # Provides access to the QueryStatsHolder
  def queries
    ActiveRecord::Base.connection.queries
  end
end