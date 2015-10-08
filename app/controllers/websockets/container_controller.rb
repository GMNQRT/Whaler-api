class Websockets::ContainerController < WebsocketRails::BaseController

  def initialize_session
    controller_store[:users] = {}
  end

  def watchlogs
    if container_id = message[:container]
      if controller_store[:users].has_key? container_id # If daemon is already running
        controller_store[:users][container_id] << connection.id
      else
        controller_store[:users][container_id] = [ connection.id ]
        %x(rake monit:log:start['#{container_id}']) # Start daemon
      end
    end
  end


  def unwatchlogs
    container_id = message[:container]

    if container_id and controller_store[:users].has_key? container_id # If daemon is already running
      unless (connection_index = controller_store[:users][container_id].index(connection.id)).nil?
        controller_store[:users][container_id].delete_at connection_index # Remove user form container watcher

        if controller_store[:users][container_id].empty? # No user left
          controller_store[:users].delete container_id
          %x(rake monit:log:stop['#{container_id}']) # Stop daemon
        end
      end
    end
  end


  def delete_user
    controller_store[:users].each do |container_id, connection_ary| # for each container
      connection_ary.delete_at(connection_ary.index(connection.id) || connection_ary.length) # Remove user form container watcher

      if connection_ary.empty? # No user left
        controller_store[:users].delete container_id
        %x(rake monit:log:stop['#{container_id}']) # Stop daemon
      end
    end
  end
end
