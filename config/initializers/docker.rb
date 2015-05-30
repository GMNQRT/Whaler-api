require 'yaml'

module WhalerApi
  docker_config       = YAML.load_file('config/docker.yml')[Rails.env].deep_symbolize_keys
  cert_path           = ENV['DOCKER_CERT_PATH'] || docker_config[:ssl_options].try(:[], :cert_path)
  default_ssl_options = { client_cert: 'cert.pem', client_key: 'key.pem', ssl_ca_file: 'ca.pem' }
  ssl_options         = default_ssl_options.merge docker_config[:ssl_options]

  if cert_path
    cert_path = File.expand_path cert_path

    default_ssl_options.each do |key, value|
      Docker.options[key] = File.join(cert_path, ssl_options[key])
    end
  end
  Docker.options[:scheme] = ssl_options[:scheme] if ssl_options[:scheme]
  Docker.url              = docker_config[:url]

  Docker.validate_version!
end