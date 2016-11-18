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
end
