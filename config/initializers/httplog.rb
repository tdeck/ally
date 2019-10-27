HttpLog.configure do |config|
  config.logger = Rails.logger
  config.log_headers = true # Why would this default to false?
end
