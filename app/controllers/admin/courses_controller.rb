module Admin
  class CoursesController < Admin::ApplicationController
    def new
      resource = Course.new

      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      resource = Course.new(permited_params)

      if !WeekdayMenu::WEEKDAYS.include?(to_weekday(Date.today))
        redirect_to admin_courses_path, notice: 'Courses can be added only for weekdays.'
      elsif resource.save
        add_to_menu(resource)

        redirect_to(
            [namespace, resource],
            notice: translate_with_resource('create.success'),
        )
      else
        render :new, locals: {
            page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def update
      if requested_resource.update(permited_params)
        redirect_to(
            [namespace, requested_resource],
            notice: translate_with_resource('update.success'),
        )
      else
        render :edit, locals: {
            page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

    protected
      def permited_params
        params.require(:course).permit(:title, :course_type, :price, :photo)
      end

      def add_to_menu(course)
        course.weekday_menus.create!(weekday: to_weekday(Date.today))
      end

      def to_weekday(date)
        date.strftime('%A').downcase
      end
  end
end
