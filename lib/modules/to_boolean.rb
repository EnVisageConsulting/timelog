module ToBoolean
  def self.convert value
    ActiveRecord::Type::Boolean.new.cast value
  end
end

def ToBoolean value
  ToBoolean.convert value
end