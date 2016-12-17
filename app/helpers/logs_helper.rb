module LogsHelper
  def link_to_remove_project(f)
    parts = []
    parts.push link_to(icon("minus-circle", "Remove Project", class: 'alert-text'), "javascript:void(0);", tabindex: -1, class: 'remove-project-link')
    parts.push f.hidden_field(:_destroy) if f.object.persisted?
    parts.join.html_safe
  end

  def link_to_add_project(f, association)
    new_object   = f.object.class.reflect_on_association(association).klass.new
    partial_name = association.to_s.singularize + "_fields"
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(partial_name, :fields_for => builder)
    end

    link_to icon("plus-circle", "Add Project"), "javascript:void(0);",
      class:    "add-project-link button expanded no-margin",
      data:     {
        field_hash: {
          association: association,
          content:     fields.gsub("\n", "")
        }.to_json
      }
  end

  def log_title log
    start_at = log.start_at.in_time_zone(TIMEZONE)
    end_at   = log.end_at.in_time_zone(TIMEZONE)

    readable_date_range(start_at, end_at)
  end

  def log_days_of_week(log)
    start_at = log.start_at.in_time_zone(TIMEZONE)
    end_at   = log.end_at.in_time_zone(TIMEZONE)

    value = start_at.strftime("%a")
    value << " - " << end_at.strftime("%a") if start_at.day != end_at.day
    value
  end
end
