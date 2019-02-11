module NewslettersHelper
  HIDDEN_EVENT_FIELDS = [:id, :month, :mday, :wday]
  MAX_ARTICLES = 3

  def default_lead_html
    Setting.get_str(SettingsKeys::NEWSLETTER_LEAD_HTML)
  end
end
