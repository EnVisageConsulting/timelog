module ApplicationHelper
  # mm/dd/yyyy hh:mm xm
  def input_datetime datetime
    return nil unless datetime
    datetime.in_time_zone(TIMEZONE).strftime("%m/%d/%Y %I:%M %p")
  end

  def readable_date_range(start_at, end_at)
    value = start_at.strftime("%b %-e, %Y")

    return value unless end_at.present?

    if start_at.month != end_at.month
      value = value.gsub /\A\w{3} \d+/ do |match|
        match + " - #{end_at.strftime("%b %-e")}"
      end
    elsif start_at.day != end_at.day
      value = value.gsub /\A\w{3} \d+/ do |match|
        match + " - #{end_at.strftime("%-e")}"
      end
    end

    value
  end

  def strip_insignificant_zeros value, decimals=1
    number_with_precision value, strip_insignificant_zeros: true, precision: decimals
  end

  def form_errors(object, options={})
    return unless object.present?
    errors = case object
             when ActiveRecord::Base,
                  TablelessModel      then object.errors.full_messages
             when String              then Array(object)
             when Array               then object
             else
               return
             end
    return unless errors.present?

    render 'shared/form_errors', errors:  errors
  end

  def viewing_deactivated?
    params[:deactivated] == 'true'
  end

  def deactivated_view_toggle_link resource=nil
    resource ||= params[:controller].to_sym
    icon_name  = "battery-#{viewing_deactivated? ? 'full' : '1'}"
    text_value = "View #{viewing_deactivated? ? 'A'  : 'Dea'}ctivate#{'d' unless viewing_deactivated?} #{resource.to_s.titleize}"

    link_to fa_icon(icon_name, text: text_value), polymorphic_url(resource, deactivated: !viewing_deactivated?)
  end

  def back_link value, path, options={}
    icon_name = options.delete(:icon)
    value     = fa_icon(icon_name || 'arrow-circle-left', text: value) unless icon_name == false

    content_for :back_link do
      content_tag :div, class: 'row back-link' do
        content_tag :div, class: 'column' do
          link_to value, path, options
        end
      end
    end
  end

  def duration start_at, end_at, hours=false
    return "--" if end_at.blank?

    diff = end_at - start_at

    if hours
      strip_insignificant_zeros(Seconds.to_hrs(diff)).to_i
    elsif diff < 1.minute
      return pluralize(strip_insignificant_zeros(diff), "second")
    elsif diff < 1.hour
      return pluralize(strip_insignificant_zeros(Seconds.to_mins(diff)), "minute")
    else
      return pluralize(strip_insignificant_zeros(Seconds.to_hrs(diff)), "hour")
    end
  end
end
