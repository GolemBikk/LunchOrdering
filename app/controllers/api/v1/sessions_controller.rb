class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token,
                     if: -> { request.format.json? },
                     only: [:create]

  respond_to :json

  def create
    if authenticate_by_params?
      render json: resource, serializer: UserSerializer, status: :ok
    else
      render json: @error_message, status: :bad_request
    end
  end

  private

  def authenticate_by_params?
    self.resource = User.find_by_email(params[:email])
    if resource.nil?
      @error_message = 'Invalid email'
      false
    elsif resource.valid_password?(params[:password])
      true
    else
      @error_message = 'Invalid password'
      false
    end
  end
end