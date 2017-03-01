# Custom logic to attempt to expand every URI
class Embiggen::ExpandEverything
  def self.include?(*)
    true
  end
end

Embiggen.configure do |config|
  config.timeout = 10
  config.redirects = 4
  config.shorteners = Embiggen::ExpandEverything
end
