Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  :address              => ENV["EMAILER_HOST"],
  :port                 => ENV["EMAILER_PORT"],
  :user_name            => ENV["EMAILER_USERNAME"],
  :password             => ENV["EMAILER_PASSWORD"],
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
Rails.application.config.action_mailer.default_options = {
  :from => ENV["EMAILER_FROM"]
}
