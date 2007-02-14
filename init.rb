require 'benchmark'

if defined?(Rails::VERSION::STRING) && Rails::VERSION::STRING < "1.2.0"
  $stderr.puts "The QueryStats plugin requires Rails >= 1.2.0"
else
  ActiveRecord::Base.connection.class.send :include, QueryStats::Recorder
  ActionController::Base.send :include, QueryStats::Labeler
  ActionController::Base.helper QueryStats::Helper
end
