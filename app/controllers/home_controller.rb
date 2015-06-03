require 'docker'

class HomeController < ApplicationController
  before_action :authenticate_user_from_token!
  respond_to :json

  def index
    # sign_out current_user
    values = {
      :version => Docker.version,
      :info => Docker.info,
    }
    respond_with values
  end
end
