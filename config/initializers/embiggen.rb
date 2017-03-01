Embiggen.configure do |config|
  config.timeout = 10
  config.redirects = 5
  config.shorteners += %w[smarturl.it avantlink.com]
end

# temporary tweak: use GET instead of HEAD because avantlink.com is buggy
module Embiggen
  class HttpClient
    private

    def request(timeout)
      http.open_timeout = timeout
      http.read_timeout = timeout

      http.get(uri.request_uri)
    end
  end
end
