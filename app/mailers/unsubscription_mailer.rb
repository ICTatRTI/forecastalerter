class UnsubscriptionMailer < ApplicationMailer
	default from: 'USAID Business Forecast <noreply@rti-ghd.org>'
 
  def good_bye_email(user)
    @user = user[0]
    if @user != nil
    	mail(to: @user.email, subject: 'Goodbye from the USAID Business Forecast')
    end
  end
end
