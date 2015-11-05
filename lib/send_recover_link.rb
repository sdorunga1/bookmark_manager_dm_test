class SendRecoverLink
  require 'mailgun'

  def self.call(user)
    new.call(user)
  end

  def call(user)
    mailer.send_message("sandbox_domain_name_for_your_account.mailgun.org", {from: "bookmarkmanager@mail.com",
        to: user.email,
        subject: "reset your password",
        text: "click here to reset your password http://yourherokuapp.com/reset_password?token=#{user.token}" })
  end

  private

  def mailer
    Mailgun::Client.new "your_mailgun_api_key"
  end

end
