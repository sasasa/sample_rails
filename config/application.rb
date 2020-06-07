require_relative 'boot'
require 'csv'
require 'payjp'
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Asia/Tokyo'

    # ロガーを日ごとにlog/development.log.yyyymmddとする
    config.logger = Logger.new('log/development.log', 'daily')

    # エラー画面を開発する時
    # consider_all_requests_local = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.assets false
      g.helper false
      g.jbuilder false

      g.test_framework :rspec, 
            view_specs: false, 
            helper_specs: false, 
            controller_specs: false, 
            routing_specs: false,
            fixtures: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
