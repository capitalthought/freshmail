class UserMailer < ActionMailer::Base
  default :from => "from@example.com",
          :reply_to => "c186abe0cc95dc02d46a@cloudmailin.net"
  
  def welcome_email(user)
    @user = user
    @url = new_user_session_url
    
    mail(:to => user.email,
         :subject => "Welcome to FreshMail")
  end
  
  def timecard_email(user)
    @user = user
    
    mail(:to => user.email,
         :subject => "Your Timesheet")
  end
end
