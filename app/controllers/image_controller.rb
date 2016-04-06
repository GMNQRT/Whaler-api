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
    @image     = Docker::Image.create(fromImage: "#{params[:id]}:#{params[:tag]}")
    @container = Docker::Container.create(Image: "#{params[:id]}:#{params[:tag]}")

    @container.start
    respond_to do |format|
      format.json { render json: @container }
    end
  end
end
