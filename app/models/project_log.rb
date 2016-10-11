class ProjectLog < ApplicationRecord
  # --- Associations --- #
  belongs_to :log
  belongs_to :project

  # --- Validations --- #
  validates :project_id,          presence: true
  validates :description,         presence: true
  validates :total_allocation,    presence: true
  validates :billable_allocation, presence: true
  validates :percent,             presence: true

  validates_numericality_of :percent, less_than_or_equal_to: 100, message: "cannot be greater than 100%"
  validates_numericality_of :percent, greater_than_or_equal_to: 0, message: "cannot be less than 0%"

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
