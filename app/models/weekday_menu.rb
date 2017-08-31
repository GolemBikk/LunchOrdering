class WeekdayMenu < ApplicationRecord
  WEEKDAYS = %w[monday tuesday wednesday thursday friday]

  belongs_to :course

  validates :weekday, presence: true,
            inclusion: { in: WEEKDAYS }
  validates :course_id, presence: true

  def self.weekdays
    WEEKDAYS
  end
end
