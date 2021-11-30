require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.generators do |g|
      g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
    end
  end
end
