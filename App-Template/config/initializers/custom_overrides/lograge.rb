Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    # No params? Must be ActionCable.
    return {} unless event.payload[:params].present?

    exceptions = %w[controller action format authenticity_token]

    {
      params: event.payload[:params].except(*exceptions)
    }
  end

  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      remote_ip: controller.request.remote_ip,
      api_key: controller.request.headers.env['HTTP_X_APIKEY']
    }
  end
end
