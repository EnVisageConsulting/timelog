class PasswordRecovery < ApplicationRecord
  has_secure_token

  # --- Associations --- #
  belongs_to :user

  # --- Validations --- #
  validates :user, presence: { message: "with that email doesn't exist" }

  # --- Callbacks --- #
  before_validation :set_expiration

  def set_expiration
    return if expires_at.present?

    self.expires_at = 1.day.from_now
  end

  # --- Setters & Getters --- #
  def email; user.try(:email); end
  def email=(value)
    self.user = value.present? ? User.with_email(value) : nil
  end

  # --- Instance Methods --- #
  def to_param; token; end

  def expired?
    expires_at && expires_at <= Time.current
  end

  def expire!
    self.expires_at = Time.current
    save!
  end
end
