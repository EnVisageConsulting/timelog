class UserMailer < ApplicationMailer
  def new_user_email(new_user)
    @new_user = new_user
    mail(to: "daltonjhuey@gmail.com", subject: "New User: #{@new_user.name} on EnVisage Timelog")
  end
end
