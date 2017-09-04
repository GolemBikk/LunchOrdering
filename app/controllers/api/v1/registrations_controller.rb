class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token,
                     if: -> { request.format.json? },
                     only: [:create, :update, :destroy]
  skip_before_action :authenticate_scope!
  before_action :authenticate_user_by_token, except: [:create]
  before_action :can_destroy_account, only: :destroy

  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      render json: resource, serializer: UserSerializer, status: :created
    else
      error_messages = resource.errors.messages
      render json: error_messages , status: :bad_request
    end
  end

  def update
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      render json: resource, serializer: UserSerializer, status: :ok
    else
      error_messages = resource.errors.messages
      render json: error_messages , status: :bad_request
    end
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out('user')
    yield resource if block_given?

    message = 'Record was deleted'
    render json: message, status: :ok
  end

  private
    def sign_up_params
      params.permit(:email, :password, :password_confirmation,
                    :name)
    end

    def account_update_params
      params.permit(:password, :password_confirmation, :current_password,
                    :email, :name)
    end

    def authenticate_user_by_token
      auth_token = params[:authentication_token]
      self.resource = User.find_by_authentication_token(auth_token)
      if resource.nil?
        message = 'Invalid authentication token'
        render json: message, status: :unauthorized
      end
    end

    def can_destroy_account
      if resource.is_admin?
        message =  'Sorry. Admin cannot be removed'

        render json: message, status: :bad_request
      end
    end
end