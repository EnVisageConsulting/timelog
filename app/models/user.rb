class User < ApplicationRecord
  enum role: [:employee, :admin]

  has_secure_password validations: false

  # --- Constants --- #
  EMAIL_FORMAT    = /\A[-0-9a-z.+_]+@[-0-9a-z.+_]+\.[a-z]+\z/i.freeze
  PASSWORD_FORMAT = /\A(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&_-])?[A-Za-z\d$@$!%*#?&_-]{1,}\z/.freeze


  # --- Associations --- #
  has_many :logs
  has_many :password_recoveries, dependent: :destroy


  # --- Validations --- #
  validates :first, presence: true
  validates :last, presence: true
  validates :role, presence: true, inclusion: { in: User.roles.keys, allow_blank: true }
  validates :email,
    presence:   true,
    format:     { with: EMAIL_FORMAT, allow_blank: true },
    uniqueness: { message: "has been used" },
    length:     { maximum: 256 }
  validates :password,
    confirmation: { allow_blank: true },
    length:       { in: 8..64, allow_blank: true },
    format:       {
      with:        PASSWORD_FORMAT,
      message:     'must contain at least one alphabet letter and one number (also allowed: @$!%*#?&_-)',
      allow_blank: true
    }


  # --- Scopes --- #
  scope :activated, -> { where('activated_at IS NOT NULL') }
  scope :deactivated, -> { where('deactivated_at IS NOT NULL') }
  scope :undeactivated, -> { where('deactivated_at IS NULL') }


  # --- Class Methods --- #
  def self.with_email email
    where(email: email.downcase.strip).first
  end

  # --- Setters & Getters --- #
  def email=(value)
    value = value.downcase.strip if value.is_a? String
    write_attribute(:email, value)
  end

  # --- Instance Methods --- #
  def current_log
    logs.inactive.first
  end

  def name
    "#{self.first} #{self.last}"
  end

  def reverse_name
    "#{self.last}, #{self.first}"
  end

  def deactivate! deactivate=true
    if deactivate
      self.deactivated_at ||= Time.now
    else
      self.deactivated_at = nil
    end

    save
  end
end
