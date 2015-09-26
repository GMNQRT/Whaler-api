namespace :monit do
  namespace :event do
    desc "Start deamon which monitoring docker's event"
    task start: :environment do
      start(Rails.root.join('tmp/pids', 'monit_event.pid'), Rails.root.join('log', 'monit_event.log')) do
        EventJob.perform()
      end
    end

    desc "Stop deamon which monitoring docker's event"
    task stop: :environment do
      stop(Rails.root.join('tmp/pids', 'monit_event.pid'), Rails.root.join('log', 'monit_event.log'))
    end
  end
end

# Daemonize task
def start(pid_file, log_file)
  if File.file?(pid_file)
    puts "daemon already started"
  else
    Rails.logger       = Logger.new(log_file)
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'info').upcase)

    unless ENV['DEBUG']
      Process.daemon(true, true)
    end

    Signal.trap('EXIT') do
      File.delete pid_file if File.file?(pid_file)
      abort
    end

    File.open(pid_file, 'w') { |f| f << Process.pid }
    Rails.logger.info "Start daemon..."

    begin
      yield
    rescue Interrupt
    end
  end
end

# Stop daemon
def stop(pid_file, log_file)
  if File.file?(pid_file)
    puts "Stopping daemon...\n"
    pid = File.read(pid_file).to_i
    begin
      Process.getpgid pid
      Process.kill "INT", pid
      puts "Daemon Stopped\n"
    end
    puts "Remove old pid file\n"
    File.delete pid_file
  end
end
