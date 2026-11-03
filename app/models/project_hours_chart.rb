class ProjectHoursChart
  attr_accessor :user, :start_date, :end_date

  def initialize(user, start_date, end_date)
    @user       = user
    @start_date = start_date
    @end_date   = end_date
  end

  def labels
    @labels ||= grouped_logs.sort_by { |k, v| v.map(&:hours).sum }.reverse.to_h.keys.map(&:name).join("|")
  end

  def values
    @values ||= grouped_logs.sort_by{ |k, v| v.map(&:hours).sum }.reverse.to_h.values.map { |v| v.map(&:hours).sum }.join("|")
  end

  def total_hours
    project_logs.sum(:hours)
  end

  private

    def project_logs
      @project_logs ||= ProjectLog.left_joins(:log)
                                  .includes(:project)
                                  .where("logs.user_id=?", user.id)
                                  .where("logs.activated IS TRUE")
                                  .where("logs.start_at <= ? AND logs.end_at >= ?", end_date, start_date)
    end

    def grouped_logs
      @grouped_logs ||= project_logs.group_by { |pl| pl.project }
    end
end
