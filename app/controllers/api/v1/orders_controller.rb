class Api::V1::OrdersController < ApiController
  def index
    params[:date] ||= Date.today
    orders = Order.with_courses.where(order_date: params[:date])
    if orders.any?
      render json: orders, each_serializer: OrderSerializer, status: :ok
    else
      error_message = 'No orders were found by request'
      render json: error_message, status: :not_found
    end
  end
end
