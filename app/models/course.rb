class Course < ApplicationRecord
  default_scope -> { order(price: :asc) }
  scope :first_courses, -> { where(course_type: 'first') }
  scope :main_courses, -> { where(course_type: 'main') }
  scope :beverages, -> { where(course_type: 'drink') }
  scope :menu, -> (weekday) { joins(:weekday_menus)
                              .select('courses.*, weekday_menus.weekday as weekday')
                              .where('weekday = ?', weekday) }

  has_many :weekday_menus, dependent: :destroy
  has_many :orders

  validates :title, presence: true, length: { maximum: 50 }
  validates :course_type, presence: true,
                          inclusion: { in: %w[first main drink] }
  validates :price, presence: true, numericality: { greater_than: 0 }

  mount_uploader :photo, PhotoUploader
end
