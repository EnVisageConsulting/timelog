class ProjectLog < ApplicationRecord
  # --- Associations --- #
  belongs_to :log
  belongs_to :project

  # --- Validations --- #
  validates :project_id,          presence: true
  validates :description,         presence: true
  validates :total_allocation,    presence: true
  validates :billable_allocation, presence: true
end
