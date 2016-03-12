class ContainerController < ApplicationController
  def index
    @Containers = Docker::Container.all(:all => true)
    respond_with @Containers.collect { |container| Docker::Container.get(container.id) }
  end

  def search
    respond_with params[:term] ? Docker::Container.search(term: params[:term]) : []
  end

  def show
    @Container = Docker::Container.get(params[:id])
    respond_with @Container
  end

  def destroy
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.delete(:force => true)
  end

  def start
    @Container = Docker::Container.get(params[:id])
    respond_with(if @Container.info['State']['Paused'] then @Container.unpause! else @Container.start! end)
  end

  def stop
    @Container = Docker::Container.get(params[:id])
    @Container.unpause! if @Container.info['State']['Paused']
    respond_with @Container.stop!
  end

  def pause
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.pause!
  end

  def unpause
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.unpause!
  end

  def restart
    @Container = Docker::Container.get(params[:id])
    respond_with @Container.restart
  end

  def update
    @Container = Docker::Container.get(params[:id])

    if @Container.info['State']['Running']
      @Container.restart! params.require(:container).require(:info).require(:HostConfig)
    else
      @Container.start! params.require(:container).require(:info).require(:HostConfig)
    end

    respond_to do |format|
      format.all { render nothing: true, status: 204 }
    end
  end
end
