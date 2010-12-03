class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(user)
    @user = user
    @url = new_user_session_url
    
    mail(:to => user.email,
         :subject => "Welcome to FreshMail")
  end
end
