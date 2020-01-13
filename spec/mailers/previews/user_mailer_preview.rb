# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user_email
    user = User.new(first: "Michael", last: "Brinkman", email: "fh_pledge@michael.com", password: "bigTimepledge", role: 0)

    UserMailer.new_user_email(user)
  end
end
