# Patch for datas lost when Docker::Image objects are materialized after a search
# See https://github.com/swipely/docker-api/issues/88
class Docker::Image

  class << self
    # Given a query like `{ :term => 'sshd' }`, queries the Docker Registry for
    # a corresponding Image.
    def patched_search(query = {}, connection = Docker.connection)
      body = connection.get('/images/search', query)
      hashes = Docker::Util.parse_json(body) || []
      #hashes.map { |hash| new(connection, 'id' => hash['name']) }
      hashes.map { |hash| new(connection, hash.merge('id' => hash['name'])) }
    end

    alias_method :search, :patched_search
  end

end