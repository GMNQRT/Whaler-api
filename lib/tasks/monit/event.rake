import 'lib/tasks/daemonize.rb'

namespace :monit do
  namespace :event do

    desc "Start daemon which monitoring docker's event"
    task start: :environment do
      start_daemon(Rails.root.join('tmp/pids', 'monit_event.pid'), Rails.root.join('log', 'monit_event.log')) do
        begin
          Docker::Event.stream(filters: { event: [:attach, :commit, :copy, :create, :destroy, :die, :exec_create, :exec_start, :export, :kill, :oom, :pause, :rename, :restart, :start, :stop, :top, :unpause] }.to_json) do |event|
            WebsocketRails[:container].trigger :event, event: event, container: (Docker::Container.get(event.id) rescue nil)
          end
        rescue
          retry
        end
      end
    end


    desc "Stop daemon which monitoring docker's event"
    task stop: :environment do
      stop_daemon(Rails.root.join('tmp/pids', 'monit_event.pid'), Rails.root.join('log', 'monit_event.log'))
    end
  end
end
