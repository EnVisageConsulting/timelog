class Reports::InvoiceReport < TablelessModel
  validates :project, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :project, :start_at, :end_at

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

  def project_logs(reload=false)
    return @project_logs if defined?(@project_logs) && !reload
    return ProjectLog.none if [project, start_at, end_at].any?(&:blank?)

    log_ids       = Log.within(start_at, end_at).pluck(:id)
    @project_logs = project.project_logs.where(log_id: log_ids).includes(:log => :user)
  end

  def grouped_project_logs
    return project_logs unless project_logs.present?
    project_logs.group_by { |project_log| project_log.log.user }
  end

  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.project  = nil
    end
end