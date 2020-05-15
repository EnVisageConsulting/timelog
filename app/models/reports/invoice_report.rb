require 'date_time_parser'

class Reports::InvoiceReport < TablelessModel
  validates :projects, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  attr_accessor :projects, :start_at, :end_at

  def initialize(attributes = {})
    set_default_attrs
    super attributes
  end

  def project_ids
    self.projects&.map{|p| p.id}
  end

  def project_ids= value
    value.reject!(&:blank?)
    self.projects = Project.find(value)
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

  def project_logs(project, reload=false)
    return ProjectLog.none if [projects, start_at, end_at].any?(&:blank?)

    log_ids       = Log.within(start_at, end_at).pluck(:id)
    project_logs = ProjectLog.where(log_id: log_ids).where(project: project).where(non_billable: false).includes(:log => :user)
  end

  def grouped_project_logs(project)
    project_logs(project).group_by { |project_log| project_log.log.user }
  end

  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.projects = nil
    end
end