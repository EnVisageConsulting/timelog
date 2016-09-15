class Project < ApplicationRecord
  # --- Associations --- #
  has_many :client_projects
  has_many :project_logs

  # --- Validations --- #
  validates :name, presence: true
end
