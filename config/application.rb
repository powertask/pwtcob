require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pwtcob
  class Application < Rails::Application
    config.app_generators.scaffold_controller :responders_controller
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = :"pt-BR"
  end
end
