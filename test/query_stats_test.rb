require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class NamedThing < ActiveRecord::Base
end

class QueryStatsTest < Test::Unit::TestCase
  include QueryStatsHelper
  fixtures :named_things

  def setup
    queries.clear
    raise "setup failed" unless queries.count == 0
  end
  
  def test_columns
    NamedThing.columns
    stats = queries.stats.last
    assert_equal :columns, stats[:type]
  end
  
  def test_select_count
    NamedThing.count
    stats = queries.stats.last
    assert_equal :select, stats[:type]
  end
  
  def test_find_by_sql
    ActiveRecord::Base.find_by_sql("SELECT * FROM named_things")
    stats = queries.stats.last
    assert_equal :select, stats[:type]
  end
  
  def test_delete
    NamedThing.delete_all
    stats = queries.stats.last
    assert_equal :delete, stats[:type]
  end
  
  def test_insert
    thing =  NamedThing.new(:name => 'irrelevant')
    thing.save
    stats = queries.stats.last
    assert_equal :insert, stats[:type]
  end
  
  def test_update
    thing = NamedThing.find(:first)
    thing.update_attributes({:name => 'new name'})
    stats = queries.stats.last
    assert_equal :update, stats[:type]
    assert_nil stats[:label]
    assert stats[:sql].downcase.include?("update")
  end
  
  def test_count_and_clear
    assert_not_nil NamedThing.find(:first)
    assert_equal 1, queries.count
    queries.clear
    assert_equal 0, queries.count
  end
  
  def test_label
    queries.label = :test_label
    NamedThing.find(:first)
    queries.label = :test_label2
    3.times { NamedThing.find(:first) }
    assert_equal 4, queries.count
    assert_equal 1, queries.count_with_label(:test_label)
    assert_equal 3, queries.count_with_label(:test_label2)
  end
  
  def test_count_with_type
    NamedThing.update(1, :name => 'irrelevant')
    assert_equal 1, queries.count_with_type(:update)
  end
end