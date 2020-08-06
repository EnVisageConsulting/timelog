class UserMailer < ApplicationMailer
  def new_user_email(new_user)
    @new_user = new_user
    attachments.inline["EnVisage_Logo.png"] = File.read("#{Rails.root}/app/assets/images/EnVisage_Logo.png")
    mail(to: User.where(role: 1).undeactivated.pluck(:email), subject: "New User: #{@new_user.name} on EnVisage Timelog")
  end

  def user_activation_email(new_user, password_recovery)
    @new_user = new_user
    @password_recovery = password_recovery
    attachments.inline["EnVisage_Logo.png"] = File.read("#{Rails.root}/app/assets/images/EnVisage_Logo.png")
    mail(to: @new_user.email, subject: "Activate your account on EnVisage Timelog")
  end
end
