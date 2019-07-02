require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ally
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.group_slug = 'sfhumanists'

    def email_concat(user, host)
      "#{user}@#{host}".downcase
    end

    config.sysadmin_emails = [ # Separated to defeat spam
      email_concat('troy.deque', 'gmail.com'),
    ]
  end

end
