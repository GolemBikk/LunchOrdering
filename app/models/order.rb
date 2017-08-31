class Order < ApplicationRecord
  belongs_to :user
  belongs_to :first_course, class_name: 'Course'
  belongs_to :main_course, class_name: 'Course'
  belongs_to :drink, class_name: 'Course'

  validates :user_id, presence: true
  validates :order_date, presence: true
  validates :first_course_id, presence: true
  validates :main_course_id, presence: true
  validates :drink_id, presence: true
  validate :correct_order_date,
           :correct_first_course,
           :correct_main_course,
           :correct_drink

  def total_price
    first_course.price + main_course.price + drink.price
  end

  protected
    def correct_order_date
      unless order_date.nil?
        if order_date < Date.today
          errors.add(:order_date, "can't be in the past")
        end
      end
    end

    def correct_first_course
      unless first_course.nil?
        if first_course.course_type != 'first'
          errors.add(:first_course, "can't be a type other then 'first'")
        end
        unless order_date.nil?
          unless include_weekday? first_course, order_weekday
            errors.add(:first_course, 'invalid course weekday')
          end
        end
      end
    end

    def correct_main_course
      unless main_course.nil?
        if main_course.course_type != 'main'
          errors.add(:main_course, "can't be a type other then 'main'")
        end
        unless order_date.nil?
          unless include_weekday? main_course, order_weekday
            errors.add(:main_course, 'invalid course weekday')
          end
        end
      end
    end

    def correct_drink
      unless drink.nil?
        if drink.course_type != 'drink'
          errors.add(:drink, "can't be a type other then 'drink'")
        end
        unless order_date.nil?
          unless include_weekday? drink, order_weekday
            errors.add(:drink_course, 'invalid course weekday')
          end
        end
      end
    end

    def order_weekday
      order_date.strftime('%A').downcase
    end

    def include_weekday? ( course, order_weekday )
      course.weekday_menus.pluck(:weekday).include? order_weekday
    end
end