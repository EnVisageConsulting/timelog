module AdminDashboardHelper

  def hours_last_week(obj)
    sdate = 1.week.ago.beginning_of_week
    edate = sdate.end_of_week
    hours = get_hours(obj, sdate, edate)

    strip_insignificant_zeros hours
  end

  def hours_this_week(obj)
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_week
    edate = sdate.end_of_week
    hours = get_hours(obj, sdate, edate)

    strip_insignificant_zeros hours
  end

  def hours_last_month(obj)
    sdate = 1.month.ago.beginning_of_month
    edate = sdate.end_of_month
    hours = get_hours(obj, sdate, edate)

    strip_insignificant_zeros hours
  end

  def hours_this_month(obj)
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_month
    edate = sdate.end_of_month
    hours = get_hours(obj, sdate, edate)

    strip_insignificant_zeros hours
  end

  def user_link(obj)
    case obj
      when User
        link_to obj.name, obj
      else
        obj.name
    end
  end

  def total_hours_this_week

  end

  class InvalidObject < StandardError; end

  private
    def get_hours(obj, sdate, edate)
      case obj
        when User
          obj.logs.active.within(sdate, edate).map(&:hours).inject(:+) || 0
        when Project
          Log.within(sdate, edate).map(&:project_logs).flatten!.reject{|pl|pl.project_id != obj.id}.map(&:hours).inject(:+) || 0
        else
          raise InvalidObject
      end
    end
end