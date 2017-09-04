class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :can_destroy_account, only: :destroy

  protected
    def can_destroy_account
      if current_user.is_admin?
        flash[:info] = 'Sorry. Admin cannot be removed'

        redirect_to root_path
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
