module NewslettersHelper
  SHORT_INPUT_FIELDS = [:title, :url, :location]
  TEXTAREA_FIELDS = [:description_html]
  VISIBLE_FIELDS = SHORT_INPUT_FIELDS + TEXTAREA_FIELDS
end
