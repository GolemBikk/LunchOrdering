class Course < ApplicationRecord
  default_scope -> { order(price: :asc) }
  scope :menu, -> (weekday) { joins(:weekday_menus)
                              .select('courses.*, weekday_menus.weekday as weekday')
                              .where('weekday = ?', weekday) }

  has_many :weekday_menus, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :course_type, presence: true,
                          inclusion: { in: %w[first main drink] }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
