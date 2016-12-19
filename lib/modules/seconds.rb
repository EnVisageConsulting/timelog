module Seconds
  def self.to_minutes(value)
    value / 60.0
  end

  def self.to_hours(value)
    self.to_minutes(value) / 60.0
  end

  class << self
    alias :to_mins :to_minutes
    alias :to_hrs :to_hours
  end
end
