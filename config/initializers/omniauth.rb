Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :meetup,
    Rails.application.credentials.meetup_oauth[:key],
    Rails.application.credentials.meetup_oauth[:secret],
    scope: 'event_management',
  )
  # TODO scope: parameter
end
