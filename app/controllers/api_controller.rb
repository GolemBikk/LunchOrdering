class ApiController < ActionController::API
  before_action authenticate_by_token

  protected
    def authenticate_by_token
      @user = User.find_by_authentication_token(params[:authentication_token])

      if @user.nil?
        error_message = 'User unauthorized'
        render json: error_message, status: :unauthorized
      end
    end
end