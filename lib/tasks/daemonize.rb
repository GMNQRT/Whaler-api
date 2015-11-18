# Daemonize task
def start_daemon(pid_file, log_file)
  if File.file?(pid_file)
    Rails.logger.info "Daemon already started"
  else
    Rails.logger       = Logger.new(log_file)
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'info').upcase)

    if ENV['DAEMONIZE']
      Process.daemon(true, false)
    end

    Signal.trap('EXIT') do
      File.delete pid_file if File.file?(pid_file)
      abort
    end

    path = File.expand_path pid_file
    FileUtils.mkdir_p File.dirname(path) unless File.exist? path

    File.open(pid_file, 'w') { |f| f << Process.pid }
    Rails.logger.info "Start daemon..."

    begin
      yield
    rescue Interrupt
    end
  end
end

# Stop daemon
def stop_daemon(pid_file, log_file)
  if File.file?(pid_file)
    Rails.logger       = Logger.new(log_file)
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'info').upcase)

    Rails.logger.info "Stopping daemon...\n"
    pid = File.read(pid_file).to_i
    begin
      Process.getpgid pid
      Process.kill "INT", pid
      Rails.logger.info "Daemon Stopped\n"
    end
    Rails.logger.info "Remove old pid file\n"
    File.delete pid_file
  end
end
