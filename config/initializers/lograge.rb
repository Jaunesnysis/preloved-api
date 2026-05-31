Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    {
      time: Time.now.utc.iso8601,
      host: event.payload[:host],
      request_id: event.payload[:headers]&.[]("X-Request-Id")
    }
  end
end