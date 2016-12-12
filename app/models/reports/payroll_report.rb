class Reports::PayrollReport < TablelessModel
  validates :user, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :user, :start_at, :end_at

  def user_id
    self.user.try :id
  end

  def user_id= value
    self.user = User.find_by(id: value)
  end

  def start_date
    return unless start_at
    raise 'here'.inspect
  end

  def start_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime value
    end

    self.start_at = value
  end

  def end_date
    return unless end_at
    raise 'here'.inspect
  end

  def end_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime value
    end

    self.end_at = value
  end
end