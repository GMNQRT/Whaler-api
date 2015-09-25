class SocketController < WebsocketRails::BaseController

  def logs
     send_message :create_success, "task", :namespace => :tasks
  end

end
