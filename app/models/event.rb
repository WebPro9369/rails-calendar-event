class Event < ApplicationRecord
  include FlagDeleted

  belongs_to :user
  belongs_to :calendar

  validates :title, :start_time, :end_time, presence: true
  validate :validate_start_before_end, if: -> {
    start_time.present? && end_time.present?
  }
  validate :validate_calendar_owner, on: :create

  default_scope { where(deleted: false) }

  private

  def validate_start_before_end
    return if start_time < end_time

    errors.add(:start_time, 'must be after end time')
  end

  def validate_calendar_owner
    return if user_id.present? && calendar.user_id == user_id

    errors.add(:owner, 'bust be the same as the logged in user')
  end
end
