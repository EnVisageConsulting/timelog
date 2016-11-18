class Log < ApplicationRecord
  # --- Constants --- #
  DATETIME_PATTERN  = /[0-1]?\d\/[0-3]?\d\/\d{4}\s\d?\d:[0-5][0-9]\s(p|a)m/i.freeze
  DATETIME_STRFTIME = "%m/%d/%Y %I:%M %p".freeze

  # --- Associations --- #
  belongs_to :user

  has_many :project_logs
    accepts_nested_attributes_for :project_logs, reject_if: :all_blank, allow_destroy: true
  has_many :projects, through: :project_logs

  # --- Validations --- #
  validates :start_at, presence: true
  validates :end_at, presence: { if: :activated? }
  validates :project_logs, presence: { if: :end_at? }
  validate  :start_at_comes_before_end_at
  validate  :end_at_in_the_past
  validate  :project_log_allocation

  def start_at_comes_before_end_at
    return unless start_at && end_at
    errors.add(:start_at, "cannot come before the end date") if start_at > end_at
  end

  def end_at_in_the_past
    return unless end_at.present?
    errors.add(:end_at, "must be in the past") if end_at > Time.now
  end

  def project_log_allocation
    return unless project_logs.present?
    allocation = project_logs.map(&:total_allocation).inject(:+)

    if end_at? && allocation != 1.0
      errors.add(:project_logs, "%s must add up to 100%")
    elsif allocation > 1.0
      errors.add(:project_logs, "%s cannot add up to more than 100%")
    end
  end

  # --- Scopes --- #
  scope :inactive, -> { where(activated: false) }
  scope :active,   -> { where(activated: true) }
  scope :latest,   -> { order('start_at DESC') }

  # --- Callbacks --- #
  before_save :set_activation
  before_validation :set_project_log_hours

  def set_activation
    return if self.activated?

    self.activated = self.end_at.present?
  end

  def set_project_log_hours
    return unless hours

    self.project_logs.each do |project_log|
      allocation = project_log.total_allocation
      next if allocation.nil? || allocation <= 0

      project_log.hours = hours * allocation
    end
  end

  # --- Class Methods --- #
  def self.convert_to_datetime string
    # reorganize datestring from mm/dd/yyyy to dd/mm/yyyy format for parse method
    string = string.split '/'
    string = [string.second, string.first, string.third].join '/'
    string.in_time_zone TIMEZONE
  end

  # --- Setters & Getters --- #
  def start_at= value
    if value.is_a?(String) && value.match(DATETIME_PATTERN)
      value = self.class.convert_to_datetime value
    end

    write_attribute :start_at, value
  end

  def end_at= value
    if value.is_a?(String) && value.match(DATETIME_PATTERN)
      value = self.class.convert_to_datetime value
    end

    write_attribute :end_at, value
  end

  # --- Instance Methods --- #
  def hours
    return unless start_at? && end_at? && start_at <= end_at
    return 0.0 if end_at == start_at

    diff = end_at - start_at
    (diff / 60.0 ) / 60.0
  end
end
