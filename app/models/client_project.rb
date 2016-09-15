class ClientProject < ApplicationRecord
  # --- Associations --- #
  belongs_to :client
  belongs_to :project
end
