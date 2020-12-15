class ProjectTag < ApplicationRecord
  # --- Associations --- #
  belongs_to :project_log
  belongs_to :tag

  # --- Validations --- #
  validates :project_log_id, presence: true
  validates :tag_id,         presence: true
end
