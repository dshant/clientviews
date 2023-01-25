MUX_ENV_SYMBOL = Rails.env.production? ? :live : :test

MuxRuby.configure do |config|
  config.username = Rails.application.credentials[:mux][MUX_ENV_SYMBOL][:pk]
  config.password = Rails.application.credentials[:mux][MUX_ENV_SYMBOL][:sk]
end
