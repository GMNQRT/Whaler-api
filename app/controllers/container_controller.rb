require 'docker'

class ContainerController < ApplicationController
  respond_to :json
  def index
    respond_with Docker::Container.all(:all => true)
  end

  def show
    respond_with Docker::Container.get(params[:id])
  end
end
