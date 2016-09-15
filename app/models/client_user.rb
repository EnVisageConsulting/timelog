class ClientUser < ApplicationRecord
  # --- Associations --- #
  belongs_to :client
  belongs_to :user
end
