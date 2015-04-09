require 'docker'

class ContainerController < ApplicationController
  respond_to :json
  def list
    respond_with Docker::Container.all(:all => true)
  end
end
