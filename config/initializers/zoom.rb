Zoom.configure do |c|
  c.api_key = Rails.application.credentials.zoom[:api_key]
  c.api_secret = Rails.application.credentials.zoom[:api_secret]
end
