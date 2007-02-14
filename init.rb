require 'benchmark'

ActiveRecord::Base.connection.class.send :include, QueryStats::Recorder

