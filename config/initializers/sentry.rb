# frozen_string_literal: true

Sentry.init do |config|
  config.environment = Rails.env
  config.dsn = Rails.application.credentials[:sentry][:dsn]
  config.enabled_environments = ['staging', 'production']
end
