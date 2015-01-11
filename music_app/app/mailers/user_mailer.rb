class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    #@url = 'http://localhost:3000'
    @url = "http://localhost:3000/users/activate?activation_token=#{@user.activation_token}"
    mail(to: "Valued New User <user.email>",
      subject: 'Welcome to MusicHead')
  end
end
