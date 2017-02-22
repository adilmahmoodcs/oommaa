Embiggen.configure do |config|
  config.timeout = 10
  config.redirects = 4
  config.shorteners += %w[smarturl.it]
end
