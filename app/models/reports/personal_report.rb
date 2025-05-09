require 'date_time_parser'

class Reports::PersonalReport < TablelessModel
  validates :users, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :users, :start_at, :end_at, :sort_date, :deactivated_users, :partner_users

  def initialize(attributes = {})
    set_default_attrs
    super attributes
  end

  def user_ids
    self.users&.map{|u| u.id}
  end

  def user_ids= value
    value.reject!(&:blank?)
    self.users = User.find(value)
  end

  def start_date
    return unless start_at.present?
    DateTimeParser.datetime_to_string start_at, strftime: DATE_STRFTIME
  end

  def start_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime(value).beginning_of_day
    end

    self.start_at = value
  end

  def end_date
    return unless end_at.present?
    DateTimeParser.datetime_to_string end_at, strftime: DATE_STRFTIME
  end

  def end_date= value
    if value.is_a?(String) && value.match(DATE_PATTERN)
      value = DateTimeParser.string_to_datetime(value).end_of_day
    end

    self.end_at = value
  end

  def logs
    return Log.none if [users, start_at, end_at].any?(&:blank?)
    users.flat_map{|u| u.logs.within(start_at, end_at).order(:start_at).includes(:project_logs => :project)}
  end

  def grouped_logs(user)
    return logs unless logs.present?
    group_logs = logs.reject{|l| l.user != user}.group_by(&:date)
    
    if sort_date.nil? || sort_date == "desc"
      group_logs = group_logs.to_a.reverse.to_h
    end

    group_logs
  end

  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.users    = nil
    end
end