class UserMailer < ActionMailer::Base
  default from: "songswesingapp@gmail.com"

  def send_notify_admin_of_new_users(user)
    @user = user
    User.where(admin: true).find_each do |u|
      mail(to: u.email, subject: 'User Registration (SWS)')
    end
  end
end
