class Log < ApplicationRecord
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
  validate  :max_date_range
  validate  :overlapping_user_logs

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

  def max_date_range
    return unless start_at && end_at
    errors.add(:end_at, "cannot be more than 8 hours from the start date") if (end_at - start_at) > (60 * 60 * 8)
  end

  def overlapping_user_logs
    return unless start_at && end_at && user
    overlapping_log = user.logs.where.not(id: self.id).within(start_at, end_at).first

    if overlapping_log.present?
      sdate = overlapping_log.start_at.in_time_zone(TIMEZONE).strftime("%m/%d/%Y %I:%M %p")
      edate = overlapping_log.end_at.in_time_zone(TIMEZONE).strftime("%m/%d/%Y %I:%M %p")
      attr_name = start_at <= overlapping_log.end_at ? :start_at : :end_at

      errors.add attr_name, "overlaps another log from #{sdate} - #{edate}"
    end
  end

  # --- Scopes --- #
  scope :inactive, -> { where(activated: false) }
  scope :active,   -> { where(activated: true) }
  scope :latest,   -> { order('start_at DESC') }

  # find logs that overlap a daterange
  # http://stackoverflow.com/questions/325933/determine-whether-two-date-ranges-overlap
  scope :within,   -> (sdate, edate) { where("(start_at <= ?) AND (end_at >= ?)", edate, sdate) }

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

  # --- Setters & Getters --- #
  def start_at= value
    if value.is_a?(String) && value.match(DATETIME_PATTERN)
      value = DateTimeParser.string_to_datetime value
    end

    write_attribute :start_at, value
  end

  def end_at= value
    if value.is_a?(String) && value.match(DATETIME_PATTERN)
      value = DateTimeParser.string_to_datetime value
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

  def date
    return unless start_at && end_at
    sdate = DateTimeParser.datetime_to_string start_at, strftime: DATE_STRFTIME
    edate = DateTimeParser.datetime_to_string end_at, strftime: DATE_STRFTIME

    [sdate, edate].uniq.join(" - ")
  end

  def start_time
    return unless start_at
    DateTimeParser.datetime_to_string start_at, strftime: TIME_STRFTIME
  end

  def end_time
    return unless end_at
    DateTimeParser.datetime_to_string end_at, strftime: TIME_STRFTIME
  end
end
