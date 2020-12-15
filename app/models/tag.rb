require 'to_boolean'

class Tag < ApplicationRecord
  # --- Associations --- #
  has_many :project_tags

  # --- Validations --- #
  validates :name, presence: true

  # --- Scopes --- #
  scope :active, -> { where(deactivated_at: nil) }
  scope :inactive,   -> { where.not(deactivated_at: nil) }
  scope :alphabetized, -> { order('name ASC') }

  # --- Setters & Getters --- #
  def deactivated; deactivated_at?; end
  def deactivated= value
    if ToBoolean(value)
      self.deactivated_at ||= Time.now
    else
      self.deactivated_at = nil
    end
  end
end
