class ProjectLog < ApplicationRecord
  # --- Associations --- #
  belongs_to :log
  belongs_to :project
  has_many   :project_tags, autosave: true

  # --- Validations --- #
  validates :project_id,          presence: true
  validates :description,         presence: true
  validates :total_allocation,    presence: true
  validates :billable_allocation, presence: true
  validates :percent,             presence: true

  validates_numericality_of :percent, less_than_or_equal_to: 100, message: "cannot be greater than 100%"
  validates_numericality_of :percent, greater_than_or_equal_to: 0, message: "cannot be less than 0%"

  # --- Setters & Getters --- #
  def percent=(value)
    value = value.chomp('%').to_i    if value.is_a?(String)
    value = (value / 100.0).round(2) if value.present?

    self.total_allocation = value
  end

  def percent
    return if total_allocation.nil?

    (total_allocation * 100).round.to_s
  end

  def hours_two_decimals
    return unless log.start_at? && log.end_at? && log.start_at <= log.end_at
    return '%.2f' % 0.00 if log.end_at == log.start_at
    '%.2f' % self.hours
  end

  def project_tags=(values)
    values = Array(values).reject(&:blank?)

    self.project_tags.each do |existing_tag|
      values.include?(existing_tag.tag_id.to_s) ?
        values.delete(existing_tag.tag_id.to_s) :
        existing_tag.mark_for_destruction
    end

    values = values.map do |val|
      self.project_tags.build(tag_id: val)
    end
    super(values)
  end
end
