Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :meetup,
    Rails.application.credentials.dig(:meetup_oauth, Rails.env.to_sym, :key),
    Rails.application.credentials.dig(:meetup_oauth, Rails.env.to_sym, :secret),
    scope: 'event_management',
  )

  require 'httplog'
end
