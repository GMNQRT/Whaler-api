class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  # Set default format to JSON.
  before_action :set_default_response_format
  respond_to :json

  def authenticate_user_from_token!
    token = request.headers["token"].presence
    user = token && User.find_by_authentication_token(token.to_s)

    if user
      sign_in user, store: false
    else
      render nothing: true, status: :unauthorized
    end
  end


  protected

  def set_default_response_format
    request.format = :json unless params[:format]
  end
end
