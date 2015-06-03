class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user_from_token!, except: [ :create ]
  # respond_to :json

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_for_database_authentication(email: params[:email])

    if user && user.valid_password?(params[:password])
      token = user.ensure_authentication_token
      render json: { auth_token: token }
    else
      render nothing: true, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  def destroy
    current_user.authentication_token = nil
    current_user.save!
    render json: {}
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
