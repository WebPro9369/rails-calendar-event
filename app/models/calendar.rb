class Calendar < ApplicationRecord
  include FlagDeleted

  belongs_to :user
  has_many :events

  validates :title, presence: true

  default_scope { where(deleted: false) }

  def get_month_events(date)
    events.where(
      'extract(year from start_time) = ? and extract(month from start_time) = ?',
      date.year,
      date.month
    ).order(start_time: :asc)
  end
end
