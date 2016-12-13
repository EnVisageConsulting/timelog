class Reports::PayrollReport < TablelessModel
  validates :user, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :user, :start_at, :end_at

  def initialize(attributes = {})
    set_default_attrs
    super attributes
  end

  def user_id
    self.user.try :id
  end

  def user_id= value
    self.user = User.find_by(id: value)
  end

  def start_date
    return unless start_at
    DateTimeParser.datetime_to_string start_at, strftime: DATE_STRFTIME
  end

  def start_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime(value).beginning_of_day
    end

    self.start_at = value
  end

  def end_date
    return unless end_at
    DateTimeParser.datetime_to_string end_at, strftime: DATE_STRFTIME
  end

  def end_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime(value).end_of_day
    end

    self.end_at = value
  end

  def logs
    return Log.none if [user, start_at, end_at].any?(&:blank?)
    user.logs.within(start_at, end_at).includes(:project_logs => :project)
  end

  def grouped_logs
    return logs unless logs.present?
    logs.group_by(&:date)
  end

  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.user     = nil
    end
end