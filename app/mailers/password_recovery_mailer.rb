class PasswordRecoveryMailer < ApplicationMailer
  def password_reset_email(password_recovery)
    @password_recovery = password_recovery
    @user = @password_recovery.user

    mail(to: @user.email, subject: "Reset your password on EnVisage Timelog")
  end
end
