require 'docker'
require 'json'

class ContainerController < ApplicationController
  respond_to :json
  def index
    @Containers = Docker::Container.all(:all => true)
    @Containers.each do |item|
      @Container = Docker::Container.get(item.id)
      @stateNumber = 0
      if @Container.info['State']['ExitCode'] == -1
        @stateNumber = -1;
      end
      if @Container.info['State']['Dead']
        @stateNumber = 1;
      end
      if @Container.info['State']['Running']
        @stateNumber = 2;
      end
      if @Container.info['State']['Paused']
        @stateNumber = 3;
      end
      @Container.info['State']['stateNumber'] = @stateNumber
      item.info['State'] = @Container.info['State']
      # stateNumber -1 = erreur
      # stateNumber 1 = mort ?!
      # stateNumber 0 = stop
      # stateNumber 2 = start
      # stateNumber 3 = pause
    end
    respond_with @Containers
  end

  def show
    respond_with Docker::Container.get(params[:id])
  end

  def start
    @Container = Docker::Container.get(params[:id])
    if @Container.info['State']['Paused']
      @Container.unpause
    end
    respond_with @Container.start
  end

  def stop
    @Container = Docker::Container.get(params[:id])
    if @Container.info['State']['Paused']
      @Container.unpause
    end
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
