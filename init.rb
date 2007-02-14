require 'benchmark'

ActiveRecord::Base.connection.class.send :include, QueryStats::Recorder
ActionController::Base.send :include, QueryStats::Labeler
ActionController::Base.helper QueryStats::Helper