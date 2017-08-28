class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_weekday

  def index
    courses = Course.menu(params[:weekday])
    @first_courses = courses.where(course_type: 'first')
    @main_courses = courses.where(course_type: 'main')
    @beverages = courses.where(course_type: 'drink')
  end

  protected
    def check_weekday
      unless %w[monday tuesday wednesday thursday friday].include? params[:weekday]
        flash[:info] = 'Invalid weekday.'
        redirect_to home_path
      end
    end
end
