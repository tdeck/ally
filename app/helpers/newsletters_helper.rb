module NewslettersHelper
  HIDDEN_EVENT_FIELDS = [:id, :month, :mday, :wday]

  def default_lead_html
    @default_lead ||= File.read(File.join(Rails.root, 'data', 'newsletter_default_lead.html'))
  end
end
