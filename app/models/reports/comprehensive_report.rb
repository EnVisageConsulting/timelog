require 'date_time_parser'

class Reports::ComprehensiveReport < TablelessModel
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :project, :user, :start_at, :end_at

  def initialize(attributes = {})
    set_default_attrs
    super attributes
  end

  def project_id
    self.project.try :id
  end

  def project_id= value
    self.project = Project.find_by(id: value)
  end

  def user_id
    self.user.try :id
  end

  def user_id= value
    self.user = User.find_by(id: value)
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
    logs=[]
    return Log.none if [start_at, end_at].any?(&:blank?)
    logs = Log.within(start_at, end_at)
    logs = logs.where(user_id: user_id) if user_id.present?
    logs = logs.joins(:project_logs).where(project_logs: {project_id: project_id}) if project_id.present?
    logs
  end

  def all_logs
    return [] unless logs.present?
      logs
  end


  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.project  = nil
      self.user 	  = nil
    end
end