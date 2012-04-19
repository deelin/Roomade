case Rails.env
when "production"
  FB_APP_ID = '337474456307201'
  FB_SECRET = 'b5adea351b70e5b1ba3ebed671a34ca0'
when "development"
  FB_APP_ID = '185806958206909'
  FB_SECRET = '52ac5ce251c282068856c4cf8536100d'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FB_APP_ID, FB_SECRET, :scope => "email", :display => "popup"
end