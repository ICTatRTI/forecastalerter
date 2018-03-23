class UnsubscriptionMailer < ApplicationMailer
	default from: 'noreply@rti-ghd.org'
 
  def good_bye_email(user)
    @user = user[0]
    mail(to: @user.email, subject: 'Good bye from the USAID Business Forecast')
  end
end
