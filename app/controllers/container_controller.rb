class ContainerController < ApplicationController
  before_action :authenticate_user_from_token!
  
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

  def binds
    @Container = Docker::Container.get(params[:id])
    bindings = params.require(:data)

    if bindings[:Links]
      bindings[:Links].each do |link|
        container = Docker::Container.get(link.split(':', 2).first[1..-1])
        container.start! if @Container.info['State']['Running']
      end
    end
    if @Container.info['State']['Running'] # restart seems not working
      @Container.stop!()
      @Container.wait()
      respond_with @Container.start! bindings
    else
      respond_with @Container.start! bindings
    end
  end
end
