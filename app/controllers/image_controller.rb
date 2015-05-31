class ImageController < ApplicationController

  respond_to :json
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
end
