module Admin
  class CoursesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Course.
    #     page(params[:page]).
    #     per(10)
    # end

    def new
      @resource = Course.new
      render locals: {
          page: Administrate::Page::Form.new(dashboard, @resource),
      }
    end

    def create
      @resource = Course.new(permited_params)

      if @resource.save
        @resource.weekday_menus.create(weekday: Date.today.strftime('%A').downcase)
        redirect_to(
            [namespace, @resource],
            notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
            page: Administrate::Page::Form.new(dashboard, @resource),
        }
      end
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Course.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    protected
      def permited_params
        params.require(:course).permit(:title, :course_type, :price)
      end
  end
end
