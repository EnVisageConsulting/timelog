class User < ApplicationRecord
  enum role: [:employee, :admin, :partner]

  has_secure_password validations: false

  # --- Constants --- #
  EMAIL_FORMAT    = /\A[-0-9a-z.+_]+@[-0-9a-z.+_]+\.[a-z]+\z/i.freeze
  PASSWORD_FORMAT = /\A(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&_-])?[A-Za-z\d$@$!%*#?&_-]{1,}\z/.freeze


  # --- Associations --- #
  has_many :logs
  has_many :password_recoveries, dependent: :destroy
  has_many :partner_project_links
  has_many :partner_projects, through: :partner_project_links, source: :project
  has_many :partner_tag_links
  has_many :partner_tags, through: :partner_tag_links, source: :tag

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
  validates :partner_projects, presence: {if: :partner?}

  # --- Scopes --- #
  scope :activated, -> { where('activated_at IS NOT NULL').order(:last) }
  scope :deactivated, -> { where('deactivated_at IS NOT NULL').order(:last) }
  scope :undeactivated, -> { where('deactivated_at IS NULL').order(:last) }
  scope :alphabetized, -> { order('last ASC') }


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

  # def deactivated_name
  #   name + (self.active? ? "" : " *")
  # end

  def status_name
    n = name
    n += " *" unless self.active?
    n += " ᵖ" if self.partner?
    n
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

  def activate!
    self.activated_at = Time.now
    save
  end

  def activated?
    activated_at?
  end

  def active?
    activated? && self.deactivated_at.nil?
  end

  def update_password(password_hash, current_user)
    _current      = password_hash[:current]
    _new          = password_hash[:new]
    _confirmation = password_hash[:confirmation]

    if !(current_user.admin? && current_user != self)
      if _current.blank?
        errors.add(:current_password, "is required")
      elsif authenticate(_current) != self
        errors.add(:current_password, "didn't match supplied password")
      end
    end

    errors.add(:new_password, "is required") if _new.blank?
    errors.add(:password_confirmation, "is required") if _confirmation.blank?

    return false if errors.present?

    self.password = _new
    self.password_confirmation = _confirmation
    self.save
  end
end
