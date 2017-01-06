require 'raven'
require 'rails'

module Raven
  class Railtie < ::Rails::Railtie
    initializer "raven.use_rack_middleware" do |app|
      app.config.middleware.insert 0, "Raven::Rack"
    end

    config.after_initialize do
      Raven.configure(true) do |config|
        config.logger ||= ::Rails.logger
        config.project_root ||= ::Rails.root
        config.release ||= config.detect_release # if project_root has changed, need to re-check
      end

      if defined?(::ActionDispatch::DebugExceptions)
        require 'raven/rails/middleware/debug_exceptions_catcher'
        ::ActionDispatch::DebugExceptions.send(:include, Raven::Rails::Middleware::DebugExceptionsCatcher)
      elsif defined?(::ActionDispatch::ShowExceptions)
        require 'raven/rails/middleware/debug_exceptions_catcher'
        ::ActionDispatch::ShowExceptions.send(:include, Raven::Rails::Middleware::DebugExceptionsCatcher)
      end
    end
  end
end
