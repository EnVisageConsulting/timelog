class Project < ApplicationRecord
  # --- Associations --- #
  has_many :client_projects
  has_many :project_logs

  # --- Validations --- #
  validates :name, presence: true

  # --- Scopes --- #
  scope :active, -> { where(deactivated_at: nil) }
  scope :inactive,   -> { where.not(deactivated_at: nil) }
  scope :alphabetized, -> { order('name ASC') }
end
