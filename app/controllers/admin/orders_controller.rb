module Admin
  class OrdersController < Admin::ApplicationController
    def index
      params[:date] ||= Date.today
      resources = Order.where(order_date: params[:date])
      if resources.blank?
        redirect_to admin_calendar_path, notice: 'No orders was found for selected date.'
        return
      end
      resources = resources.includes(*resource_includes) if resource_includes.any?
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)
      @total_price = Order.total_price resources

      render locals: {
          resources: resources,
          page: page,
      }
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
