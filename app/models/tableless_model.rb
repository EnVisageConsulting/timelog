class TablelessModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # set attributes through attr_accessor. Example:
  # attr_accessor :whatever

  def initialize(attributes = {})
    attributes.is_a?(Hash) && attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end