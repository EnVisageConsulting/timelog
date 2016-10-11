class ProjectLog < ApplicationRecord
  # --- Associations --- #
  belongs_to :log
  belongs_to :project

  # --- Validations --- #
  validates :project_id,          presence: true
  validates :description,         presence: true
  validates :total_allocation,    presence: true
  validates :billable_allocation, presence: true

  # --- Setters & Getters --- #
  def percent=value
    value = value.chomp('%').to_i if value.is_a?(String)

    self.total_allocation = value.nil? ? value : (value / 100.0).round(2)
  end

  def percent
    return if total_allocation.nil?

    (total_allocation * 100).round.to_s
  end
end
