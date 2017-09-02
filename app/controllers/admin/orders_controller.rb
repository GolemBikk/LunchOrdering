module Admin
  class OrdersController < Admin::ApplicationController
    def index

    end

    def calendar
      params[:start_date] ||= Date.today
      @orders_count = Order.count_by_dates(current_week params[:start_date].to_date)
    end

    protected
      def current_week(date)
        date.beginning_of_week..(date.beginning_of_week + 6)
      end
  end
end
