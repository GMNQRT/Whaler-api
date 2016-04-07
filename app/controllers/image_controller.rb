class ImageController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    respond_with Docker::Image.all
  end

  def show
    respond_with Docker::Image.get(params[:id])
  end

  def history
    respond_with Docker::Image.get(params[:id]).try :history
  end

  def search
    respond_with params[:term] ? Docker::Image.search(term: params[:term]) : []
  end

  def tags
    if params[:image]
      respond_with JSON.load(open("https://registry.hub.docker.com/v1/repositories/#{params[:image]}/tags"))
    else
      respond_with []
    end
  end

  def destroy
    @Image = Docker::Image.get(params[:id])
    respond_with @Image.delete(:force => true)
  end

  def run
    container_config = {}
    config           = params.require(:config)

    container_config[:Image]        = config[:tag].present? ? "#{params[:id]}:#{config[:tag][:name]}" : params[:id]
    container_config[:AttachStdout] = true
    container_config[:Cmd]          = config[:command].split " "
    container_config[:Entrypoint]   = config[:entrypoint].present? ? config[:entrypoint] : nil
    container_config[:WorkingDir]   = config[:workingdir]
    container_config[:name]         = config[:name]
    container_config[:ExposedPorts] = {}
    container_config[:HostConfig]   = {
      portBindings: {},
      Binds: []
    }

    if config[:exposedPorts].present?
      config[:exposedPorts].each do |exposedPorts|
        if exposedPorts[:port].present? and exposedPorts[:protocol].present?
          container_config[:ExposedPorts]["#{exposedPorts[:port]}/#{exposedPorts[:protocol]}"] ||= {}
        end
      end
    end
    if config[:portBindings].present?
      config[:portBindings].each do |portBinding|
        if portBinding[:container].present? and portBinding[:protocol].present? and portBinding[:host].present?
          container_config[:ExposedPorts]["#{portBinding[:container]}/#{portBinding[:protocol]}"] ||= {}
          container_config[:HostConfig][:portBindings]["#{portBinding[:container]}/#{portBinding[:protocol]}"] ||= []
          container_config[:HostConfig][:portBindings]["#{portBinding[:container]}/#{portBinding[:protocol]}"].push({ HostPort: "#{portBinding[:host]}" })
        end
      end
    end
    if config[:binds].present?
      config[:binds].each do |volume|
        if volume[:hostDirectory].present? and volume[:name].present?
          container_config[:HostConfig][:Binds].push("#{volume[:hostDirectory]}:#{volume[:name]}")
        end
      end
    end

    @container = Docker::Container.create(container_config)
    render json: @container
  end
end
