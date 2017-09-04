module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin

    def authenticate_admin
      unless current_user.is_admin?
        flash[:warning] = 'You have not admin roots'
        redirect_to home_path
      end
    end
  end
end
