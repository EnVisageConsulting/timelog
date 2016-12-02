class PasswordRecovery < ApplicationRecord
  has_secure_token

  # --- Associations --- #
  belongs_to :user

  # --- Setters & Getters --- #
  def email; user.try(:email); end
  def email=(value)
    self.user = value.present? ? User.with_email(value) : nil
  end
end
