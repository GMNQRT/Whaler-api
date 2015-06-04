require 'docker'

class ContainerController < ApplicationController
  respond_to :json
  def index
    respond_with Docker::Container.all(:all => true)
  end

  def show
    respond_with Docker::Container.get(params[:id])
  end

  def start
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.start
  end

  def stop
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.stop
  end

  def pause
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.pause
  end

  def unpause
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.unpause
  end

  def restart
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.restart
  end
end
