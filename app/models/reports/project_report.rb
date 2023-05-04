require 'date_time_parser'

class Reports::ProjectReport < TablelessModel
  validates :projects, presence: true
  # validates :start_at, presence: true
  # validates :end_at, presence: true

  attr_accessor :projects, :users, :project_tags, :start_at, :end_at, :sort_date, :deactivated_projects, :include_partners

  def initialize(attributes = {})
    set_default_attrs
    super attributes
  end

  def user_ids
    self.users&.map(&:id)
  end

  def user_ids= value
    value.reject!(&:blank?)
    self.users = User.find(value)
  end

  def project_ids
    self.projects&.map(&:id)
  end

  def project_ids= value
    value.reject!(&:blank?)
    self.projects = Project.find(value)
  end

   def project_tag_ids
    self.project_tags&.map{|p| p.id}
  end

  def project_tag_ids= value
    value.reject!(&:blank?)
    self.project_tags = Tag.find(value)
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

  def project_logs(project)
    return ProjectLog.none if projects.blank?

    log_ids =
    if start_at.present? && end_at.present?
      Log.within(start_at, end_at).pluck(:id)
    elsif start_at.present?
      Log.where("start_at >= ?", start_at)
    elsif end_at.present?
      Log.where("end_at <= ?", end_at)
    else
      Log.all
    end

    project_tags_ids = project_tags&.map(&:id)
    project_logs = ProjectLog.joins(:log).where(log_id: log_ids).where(project: project).where(non_billable: false).order(:start_at).includes(:log => :user)
    project_logs = project_logs.joins(log: :user).where(users: {id: user_ids})
    project_logs = project_logs.where.not(users: {role: :partner}) unless ToBoolean(include_partners)
    project_logs = project_logs.reject{|proj_log| proj_log.project_tags.map(&:tag_id).flat_map{|tag_id| project_tags_ids.include?(tag_id)}.all?(false)} if project_tags.present?
    project_logs
  end

  def grouped_project_logs(project)
    if sort_date == "desc"
      project_logs(project).reverse.sort_by { |project_log| project_log.log.user.last }.group_by { |project_log| project_log.log.user }
    else
      project_logs(project).sort_by { |project_log| project_log.log.user.last }.group_by { |project_log| project_log.log.user }
    end
  end

  private

    def set_default_attrs
      now = Time.now.in_time_zone(TIMEZONE)

      self.end_at   = (now    - 1.week).end_of_week
      self.start_at = (end_at - 1.week).beginning_of_week
      self.projects = nil
    end
end