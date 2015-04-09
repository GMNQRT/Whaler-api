require 'docker'

class HomeController < ApplicationController
  respond_to :json
  def index
    values = {
      :version => Docker.version,
      :info => Docker.info,
    }
    respond_with values
  end
end
