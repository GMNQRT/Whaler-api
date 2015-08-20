require 'docker'
require 'json'
require 'rails/sse'

class ContainerController < ApplicationController
  include ActionController::Live
  include Rails::SSE

  respond_to :json

  def index
    @Containers = Docker::Container.all(:all => true)
    @Containers.each do |item|
      @Container = Docker::Container.get(item.id)
      # @Container.info['State']['stateNumber'] = @stateNumber
      item.info['State'] = @Container.info['State']
      # stateNumber -1 = erreur
      # stateNumber 1 = mort ?!
      # stateNumber 0 = stop
      # stateNumber 2 = start
      # stateNumber 3 = pause
    end
    respond_with @Containers
  end

  def search
    respond_with params[:term] ? Docker::Container.search(term: params[:term]) : []
  end

  def show
    @Container = Docker::Container.get(params[:id])
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
    @Container.info['State'] = @Container.info['State']
    respond_with @Container
  end

  def destroy
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.delete(:force => true)
  end

  def start
    @Container = Docker::Container.get(params[:id])
    if @Container.info['State']['Paused']
      @Container.unpause!
      @Container.info['State']['Paused'] = false
    end
    @Container.start!
    @Container.info['State']['Running'] = true

    respond_with @Container
  end

  def stop
    @Container = Docker::Container.get(params[:id])
    if @Container.info['State']['Paused']
      @Container.unpause
      @Container.info['State']['Paused'] = false
    end
    @Container.stop!
    @Container.info['State']['Running'] = false


    respond_with @Container
  end

  def pause
    @Container = Docker::Container.get(params[:id])
    @Container.pause!
    @Container.info['State']['Paused'] = true
    respond_with @Container
  end

  def unpause
    @Container = Docker::Container.get(params[:id])
    @Container.unpause!
    @Container.info['State']['Paused'] = false
    respond_with @Container
  end

  def restart
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.restart
  end


  def logs
    container = Docker::Container.get(params[:id])
    if container
      stream do |channel|
        container.attach(stream: true) do |stream, chunk|
          channel.post(chunk, event: :logs)
        end
      end
    end
  rescue
    logger.info "error"
  ensure
    logger.info "Ended"
  end
end
