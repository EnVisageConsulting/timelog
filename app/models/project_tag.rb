class ProjectTag < ApplicationRecord
  # --- Associations --- #
  belongs_to :project_log
  belongs_to :tag

  # --- Validations --- #
  validates :project_log_id, uniqueness: { scope: :tag_id }
end
