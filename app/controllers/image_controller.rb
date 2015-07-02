class ImageController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json
  def index
    @images = Docker::Image.all
    nameImage = Array.new
    @images.each do |image|
      image.info['RepoTags'].each do |tag|
        tag.strip!
        # raise "toto"
      end
    end
    respond_with @images
  end

  def show
    respond_with Docker::Image.get(params[:id])
  end

  def create
    # image = Docker::Image.create('fromImage' => params[:fromImage])
    # image.tag('repo' => 'base2', 'force' => true)
    # image.save
    # respond_with image
  end

  def allForContainer
    @images = Docker::Image.all
    nameImage = Array.new
    @images.each do |image|
      nameImage.push(image.info['RepoTags'][0])
    end
    respond_with nameImage
  end

  def history
    respond_with Docker::Image.get(params[:id]).try :history
  end

  def search
    respond_with params[:term] ? Docker::Image.search(term: params[:term]) : []
  end
end
