class SettingsController < ApplicationController
  def index
    @newsletter_lead_html = Setting.get_str(SettingsKeys::NEWSLETTER_LEAD_HTML)
    @admin_emails = Setting.get_str(SettingsKeys::ADMIN_EMAILS)
    @hardcoded_admin_emails = Rails.application.config.sysadmin_emails
  end

  def update_all
    # We want saving this page to be atomic
    Setting.transaction do
      params.require(:settings).each do |key, value|
        Setting.set_str!(key, value)
      end
    end

    redirect_to settings_path
  end

  def show
    @setting = Setting.find_by_key(params[:id])
  end
end
