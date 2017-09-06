class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_weekday, only: [:new]

  def new
    @courses = Course.menu(params[:weekday])
    @order = current_user.orders.build(order_date: to_date(params[:weekday]))
  end

  def create
    order = Order.new(permitted_params)

    if order.save
      flash[:info] = 'Your order is accepted.'

      redirect_to home_path
    else
      get_error(order)
      weekday = to_weekday(order.order_date || Date.today)

      redirect_to new_order_path(weekday: weekday)
    end
  end

  protected
    def permitted_params
      params.require(:order).permit(:order_date,:first_course_id,
                                    :main_course_id, :drink_id, :user_id)
    end

    def check_weekday
      unless WeekdayMenu::WEEKDAYS.include?(params[:weekday])
        flash[:danger] = 'Invalid weekday.'

        redirect_to home_path
      end
    end

    def get_error(order)
      if order.errors[:order_date].any?
        flash[:danger] = order.errors.details[:order_date]
      else
        flash[:danger] = 'Your should choose available courses from all group.'
      end
    end

    def to_date (day_of_week)
      date = Date.today.beginning_of_week
      until to_weekday(date) == day_of_week do
        date = date.tomorrow
      end
      date
    end

    def to_weekday(date)
      date.strftime('%A').downcase
    end
end
