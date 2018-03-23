class SubscriptionMailer < ApplicationMailer
	default from: 'USAID Business Forecast <noreply@rti-ghd.org>'
 
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the USAID Business Forecast')
  end
end
