class UserMailer < ActionMailer::Base
  
  default :from => "timecards@freshmailer.net",
          :reply_to => ENV["CLOUDMAILIN_FORWARD_ADDRESS"] || "test@test.com"
  
  def welcome_email(user)
    @user = user
    @url = new_user_session_url
    
    mail(:to => user.email,
         :subject => "Welcome to FreshMail")
  end
  
  def timecard_email(user)
    @user = user
    
    mail(:to => user.email,
         :subject => "Your Timecard for #{Time.now.strftime("%A %B %d")}")
  end
end
