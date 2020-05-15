class UserMailer < ApplicationMailer
  def new_user_email(new_user)
    @new_user = new_user
    mail(to: "csatzler@kansas.net", subject: "New User: #{@new_user.name} on EnVisage Timelog")
  end

  def user_activation_email(new_user, password_recovery)
    @new_user = new_user
    @password_recovery = password_recovery
    mail(to: @new_user.email, subject: "Activate your account on EnVisage Timelog")
  end
end
