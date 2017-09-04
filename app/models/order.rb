class Order < ApplicationRecord
  scope :with_courses, -> { includes(:first_course, :main_course, :drink) }

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

  def self.total_price(orders)
    orders.inject(0) do |total_price, order|
      total_price + order.first_course.price +
                    order.main_course.price +
                    order.drink.price
    end
  end

  def self.count_by_dates(date_range)
    Order.group(:order_date).where(order_date: date_range).count
  end

  protected
    def correct_order_date
      unless order_date.nil?
        unless order_date == Date.today
          errors.add(:order_date, "can't be in the past or future")
        end
      end
    end

    def correct_first_course
      unless first_course.nil?
        unless first_course.course_type == 'first'
          errors.add(:first_course, "can't be a type other then 'first'")
        end
        unless order_date.nil?
          unless include_weekday?(first_course)
            errors.add(:first_course, 'invalid course weekday')
          end
        end
      end
    end

    def correct_main_course
      unless main_course.nil?
        unless main_course.course_type == 'main'
          errors.add(:main_course, "can't be a type other then 'main'")
        end
        unless order_date.nil?
          unless include_weekday?(main_course)
            errors.add(:main_course, 'invalid course weekday')
          end
        end
      end
    end

    def correct_drink
      unless drink.nil?
        unless drink.course_type == 'drink'
          errors.add(:drink, "can't be a type other then 'drink'")
        end
        unless order_date.nil?
          unless include_weekday?(drink)
            errors.add(:drink_course, 'invalid course weekday')
          end
        end
      end
    end

    def order_weekday
      order_date.strftime('%A').downcase
    end

    def include_weekday?(course)
      course.weekday_menus.pluck(:weekday).include?(order_weekday)
    end
end
