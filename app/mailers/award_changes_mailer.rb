class AwardChangesMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def awards_changed(user, changes, current_date, previous_date)
    @user = user
    @changes = changes
    @current_date = current_date
    @previous_date = previous_date
    mail(to: @user.email, subject: "Summary of USAID Business Forecast Changes - #{current_date.strftime('%m/%d/%Y')}")
  end

end