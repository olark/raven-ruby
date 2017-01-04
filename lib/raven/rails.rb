require 'raven/rails/action_controller_catcher'

module Raven
  module Rails
    def self.initialize

      if defined?(ActionController::Base)
        ActionController::Base.send(:include, Raven::Rails::ActionControllerCatcher)
      end

      if defined?(::Rails.configuration) && ::Rails.configuration.respond_to?(:middleware)
        ::Rails.configuration.middleware.insert_after 'ActionController::Failsafe', Raven::Rack
      end

      Raven.configure(true) do |config|
        config.project_root = defined?(::Rails.root) && ::Rails.root || defined?(RAILS_ROOT) && RAILS_ROOT
        config.logger ||= if defined?(::Rails.logger)
          ::Rails.logger
        elsif defined?(RAILS_DEFAULT_LOGGER)
          RAILS_DEFAULT_LOGGER
        end
        # config.release ||= config.detect_release # if project_root has changed, need to re-check
        config.release = "test"
      end

    end
  end
end

Raven::Rails.initialize
