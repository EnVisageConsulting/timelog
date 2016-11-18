module ApplicationHelper
  # mm/dd/yyyy hh:mm xm
  def input_datetime datetime
    return nil unless datetime
    datetime.in_time_zone(TIMEZONE).strftime("%m/%d/%Y %I:%M %p")
  end

  def form_errors(object, options={})
    return unless object.present?
    errors = case object
             when ActiveRecord::Base then object.errors.full_messages
             when String             then Array(object)
             when Array              then object
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

    link_to icon(icon_name, text_value), polymorphic_url(resource, deactivated: !viewing_deactivated?)
  end
end
