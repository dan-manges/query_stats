require 'benchmark'
ActiveRecord::Base.connection.class.send :include, ActiveRecord::ConnectionAdapters::QueryStats
ActionController::Base.helper(QueryStatsHelper)