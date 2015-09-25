class EventJob < ActiveJob::Base
  queue_as :default

  def self.perform
    Docker::Event.stream do |event|
      WebsocketRails[:container].trigger :event, event: event, container: Docker::Container.get(event.id)
    end
  rescue
    retry
  end
end
