import 'lib/tasks/daemonize.rb'

namespace :monit do
  namespace :log do
    desc "Start daemon which monitoring log of a given container"
    task :start, [:container_id] => :environment do |t, args|
      start_daemon(Rails.root.join('tmp/pids', "monit_container_log_#{args[:container_id]}.pid"), Rails.root.join('log', "monit_log.log")) do
        container = Docker::Container.get(args[:container_id])

        begin
          container.attach(stream: true) do |stream, chunk|
            WebsocketRails["container.#{args[:container_id]}"].trigger :log, chunk
          end
        rescue Docker::Error::TimeoutError
          retry
        end
      end
    end

    desc "Stop daemon which monitoring log of a given container"
    task :stop, [:container_id] => :environment do |t, args|
      stop_daemon(Rails.root.join('tmp/pids', "monit_container_log_#{args[:container_id]}.pid"), Rails.root.join('log', "monit_log.log"))
    end
  end
end
