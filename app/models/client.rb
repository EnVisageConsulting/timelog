class Client < ApplicationRecord
  # --- Associations --- #
  has_many :client_users
  has_many :users, through: :client_users

  has_many :client_projects
  has_many :projects, through: :client_projects

  # --- Validations --- #
  validates :name, presence: true
end
