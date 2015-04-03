require 'docker'

class ImageController < ApplicationController
  respond_to :json
  def list
    respond_with Docker::Image.all
  end
end
