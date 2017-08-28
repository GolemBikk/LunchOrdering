class WeekdayMenu < ApplicationRecord
  belongs_to :course

  validates :weekday, presence: true,
            inclusion: { in: %w[monday tuesday wednesday thursday friday] }
  validates :course_id, presence: true
end
