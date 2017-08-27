class Course < ApplicationRecord
  default_scope -> { order('hotels.created_at DESC') }

  has_many :weekday_menus

  validates :title, presence: true, length: { maximum: 50 }
  validates :course_type, presence: true,
                          inclusion: { in: %w[first main drink] }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
