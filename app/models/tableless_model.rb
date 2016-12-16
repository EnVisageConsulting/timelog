class TablelessModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # set attributes through attr_accessor. Example:
  # attr_accessor :whatever

  def initialize(attributes = {})
    [ActionController::Parameters, Hash].member?(attributes.class) && attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end