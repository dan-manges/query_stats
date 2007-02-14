module QueryStats
  def self.included(*args)
    $stderr.puts "You no longer need to include the QueryStats module in your controller."
  end
end