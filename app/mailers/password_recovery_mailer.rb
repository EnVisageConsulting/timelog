class PasswordRecoveryMailer < ApplicationMailer
  def password_reset_email(password_recovery)
    @password_recovery = password_recovery
    @user = @password_recovery.user

    attachments.inline["EnVisage_Logo.png"] = File.read("#{Rails.root}/app/assets/images/EnVisage_Logo.png")
    mail(to: @user.email, subject: "Reset your password on EnVisage Timelog")
  end
end
