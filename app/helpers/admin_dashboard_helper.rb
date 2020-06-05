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

  private
    def get_hours(obj, sdate, edate)
      hours =
      case obj
        when User
          obj.logs.active.within(sdate, edate).map(&:hours).inject(:+) || 0
        when Project
          Log.within(sdate, edate).map(&:project_logs).flatten!.reject{|pl|pl.project_id != obj.id}.map(&:hours).inject(:+) || 0
        else
          raise InvalidObject
      end
      format_hours(hours)
    end

    def get_total_time(obj, sdate, edate)
      hours =
      case obj.first
        when User
          Log.within(sdate, edate).reject{|l| !User.undeactivated.pluck(:id).include?(l.user_id)}.map(&:project_logs).flatten!.map(&:hours).inject(:+) || 0
        when Project
          Log.within(sdate, edate).map(&:project_logs).flatten!.reject{|pl| !Project.active.pluck(:id).include?(pl.project_id)}.map(&:hours).inject(:+) || 0
        else
          raise InvalidObject
      end
      format_hours(hours)
    end

    def format_hours(hours)
      hours == 0.00 ? 0 : '%.2f' % hours
    end
end