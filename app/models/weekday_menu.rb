class WeekdayMenu < ApplicationRecord
  scope :menu, -> (weekday) { includes(:course).where(weekday: weekday) }

  belongs_to :course

  validates :weekday, presence: true,
            inclusion: { in: %w[monday tuesday wednesday thursday friday] }
  validates :course_id, presence: true
end
