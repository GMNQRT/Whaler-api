class EventJob < ActiveJob::Base
  queue_as :default

  def self.perform
    Docker::Event.stream(filters: { event: [:attach, :commit, :copy, :create, :destroy, :die, :exec_create, :exec_start, :export, :kill, :oom, :pause, :rename, :restart, :start, :stop, :top, :unpause] }.to_json) do |event|
      WebsocketRails[:container].trigger :event, event: event, container: (Docker::Container.get(event.id) rescue nil)
    end
  rescue
    retry
  end
end
