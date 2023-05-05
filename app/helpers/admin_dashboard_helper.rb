module AdminDashboardHelper
  def graph_week_totals
    "#{last_week_total}|#{this_week_total}"
  end

  def graph_month_totals
    "#{last_month_total}|#{this_month_total}"
  end

  def hours_last_week(obj)
    sdate = 1.week.ago.in_time_zone(TIMEZONE).beginning_of_week
    edate = sdate.end_of_week
    get_hours(obj, sdate, edate)
  end

  def last_week_range
    sdate = 1.week.ago.in_time_zone(TIMEZONE).beginning_of_week.strftime("%m/%d/%y")
    edate = 1.week.ago.in_time_zone(TIMEZONE).end_of_week.strftime("%m/%d/%y")

    "(#{sdate} - #{edate})"
  end

  def hours_this_week(obj)
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_week
    edate = sdate.end_of_week
    get_hours(obj, sdate, edate)
  end

  def this_week_range
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_week.strftime("%m/%d/%y")
    edate = Time.now.in_time_zone(TIMEZONE).end_of_week.strftime("%m/%d/%y")

    "(#{sdate} - #{edate})"
  end

  def hours_last_month(obj)
    sdate = 1.month.ago.in_time_zone(TIMEZONE).beginning_of_month
    edate = sdate.end_of_month
    get_hours(obj, sdate, edate)
  end

  def last_month_name
    "(#{Date::MONTHNAMES[1.month.ago.in_time_zone(TIMEZONE).month]})"
  end

  def hours_this_month(obj)
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_month
    edate = sdate.end_of_month
    get_hours(obj, sdate, edate)
  end

  def this_month_name
    "(#{Date::MONTHNAMES[Date.today.month]})"
  end

  def last_week_total(obj = User.all)
    get_total_time(obj, 1.week.ago.in_time_zone(TIMEZONE).beginning_of_week, 1.week.ago.in_time_zone(TIMEZONE).end_of_week)
  end

  def this_week_total(obj = User.all)
    get_total_time(obj, Time.now.in_time_zone(TIMEZONE).beginning_of_week, Time.now.in_time_zone(TIMEZONE).end_of_week)
  end

  def last_month_total(obj = User.all)
    get_total_time(obj, 1.month.ago.in_time_zone(TIMEZONE).beginning_of_month, 1.month.ago.in_time_zone(TIMEZONE).end_of_month)
  end

  def this_month_total(obj = User.all)
    get_total_time(obj, Time.now.in_time_zone(TIMEZONE).beginning_of_month, Time.now.in_time_zone(TIMEZONE).end_of_month)
  end


  def user_link(obj)
    case obj
      when User
        link_to obj.name, obj
      else
        obj.name
    end
  end

  class InvalidObject < StandardError; end


  def get_hours(obj, sdate, edate, include_partner_hours=false)
    accessible_user_ids =
      if current_user.admin?
        (include_partner_hours ? User : User.where.not(role: :partner)).pluck(:id)
      else
        [current_user.id]
      end

    stime = sdate.in_time_zone(TIMEZONE).beginning_of_day
    etime = edate.in_time_zone(TIMEZONE).end_of_day
    hours =
    case obj
      when User
        Log.includes(:user, :project_logs).where(user_id: accessible_user_ids).within(stime, etime)&.reject { |l| l.user_id != obj.id }&.flat_map(&:project_logs)&.map(&:hours)&.inject(:+) || 0
      when Project
        Log.includes(:project_logs).where(user_id: accessible_user_ids).within(stime, etime)&.flat_map(&:project_logs)&.reject { |pl| pl.project_id != obj.id }&.map(&:hours)&.inject(:+) || 0
      else
        raise InvalidObject
    end
    format_hours(hours)
  end

  def get_months(sdate, edate)
    sdate = Date.strptime(sdate, "%m/%d/%Y")
    edate = Date.strptime(edate, "%m/%d/%Y")

    months = []
    date = sdate

    while date < edate || (date.month == edate.month && date.year == edate.year)
      months << [date.month, date.year]
      date += 1.month
    end
    months
  end

  def get_month_hours(month, obj, sdate, edate, include_partner_hours=false)
    month = Date.strptime(month[0].to_s + "/01/" + month[1].to_s, "%m/%d/%Y")
    sdate = Date.strptime(sdate, "%m/%d/%Y")
    edate = Date.strptime(edate, "%m/%d/%Y")
    start_date = month < sdate ? sdate : month
    end_date = month.end_of_month > edate ? edate : month.end_of_month

    get_hours(obj, start_date, end_date, include_partner_hours)
  end

  def format_hours(hours)
    hours == 0.00 ? 0 : '%.2f' % hours
  end

  private

    def get_total_time(obj, sdate, edate)
      hours =
      case obj.first
        when User
          Log.includes(:user, :project_logs).within(sdate, edate)&.reject{|l| !User.undeactivated.pluck(:id).include?(l.user_id)}&.flat_map(&:project_logs)&.map(&:hours)&.inject(:+) || 0
        when Project
          Log.includes(:project_logs).within(sdate, edate)&.flat_map(&:project_logs)&.reject{|pl| !Project.active.pluck(:id).include?(pl.project_id)}&.map(&:hours)&.inject(:+) || 0
        else
          raise InvalidObject
      end
      format_hours(hours)
    end
end