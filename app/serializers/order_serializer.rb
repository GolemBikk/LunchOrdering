class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user,  :total_price

  belongs_to :first_course, class_name: 'Course'
  belongs_to :main_course, class_name: 'Course'
  belongs_to :drink, class_name: 'Course'

  def user
    object.user.name
  end

  def total_price
    object.first_course.price + object.main_course.price + object.drink.price
  end
end
