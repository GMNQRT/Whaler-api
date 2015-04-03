require 'docker'

class HomeController < ApplicationController
  respond_to :json
  def index
    respond_with Docker::Image.all
  end
end
