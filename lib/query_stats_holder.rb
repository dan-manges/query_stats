# QueryStatsHolder holds data on queries executed.
# QueryStatsHolder#stats will return an array of hashes containing the following keys:
# * type: The type of SQL query based on methods in ActiveRecord::ConnectionAdapters::AbstractAdapter
#   * begin_db_transaction
#   * columns
#   * commit_db_transaction
#   * delete
#   * insert
#   * rollback_db_transaction
#   * select
#   * update
# * sql: The SQL executed.
# * name: The name passed to the adapter's execute method, may be nil.
# * seconds: The execution time in seconds.
# * label: A custom label which can be set to track queries.
class QueryStatsHolder
  # Gets or sets the current label to be applied to queries for custom tracking.
  # Including QueryStats in ApplicationController will label queries :controller or :view
  attr_accessor :label
  
  # Creates a new instance of QueryStatsHolder with an empty array of stats.
  def initialize
    @ignore_types = [:begin_db_transaction,
                     :columns,
                     :commit_db_transaction,
                     :rollback_db_transaction]
    @stats = []
  end

  # Add data to the array of stats - should only be called by the active record connection adapter.
  def add(seconds, query, name = nil, *args) #:nodoc
    @stats << {
                :sql     => query,
                :name    => name,
                :label   => @label,
                :seconds => seconds,
                :type    => @query_type
              }
  end

  # Remove the current label and clear the array of stats.
  def clear
    @label = nil
    @stats.clear
  end
  
  # Return the number of queries captured.
  def count
    @stats.length
  end
  
  # Return the number of queries executed with a given label.
  def count_with_label(label)
    with_label(label).length
  end
  
  # Return the number of queries executed with a given type.
  def count_with_type(type)
    with_type(type).length
  end
  
  # Set the query type - this should only be called automatically from the connection adapter.
  def query_type=(sym)
    @query_type = sym
    @query_type = :select if @query_type.to_s.include?("select")
  end
  
  # Return an array of query statistics collected.
  def stats
    @stats
  end
  
  # Return the total execution time for all queries in #stats.
  def total_time
    total = 0
    @stats.each {|q| total += q[:seconds]}
    total
  end
  
  # Returns an array of statistics for queries with a given label.
  # Set ignore to true to ignore transaction and column queries.
  def with_label(label, ignore = true)
    stats = @stats.collect {|q| q[:label] == label ? q : nil}.compact
    ignore ? stats.delete_if {|q| @ignore_types.include?(q[:type])} : stats
  end
  
  # Returns an array of statistics for queries with a given type.
  def with_type(type)
    @stats.collect {|q| q[:type] == type ? q : nil}.compact
  end

end