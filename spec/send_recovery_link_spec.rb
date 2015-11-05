require 'send_recover_link'

describe SendRecoverLink do
  let(:user){double :user, email: "test@test.com", token: "12345678"}
  let(:mail_gun_client){double :mail_gun_client}

  before do
    allow(Mailgun::Client).to receive(:new).and_return(mail_gun_client)
  end

  it "sends a message to mailgun when it is called" do
    params = {from: "bookmarkmanager@mail.com",
              to: user.email,
              subject: "reset your password",
              text: "click here to reset your password http://yourherokuapp.com/reset_password?token=#{user.token}" }
    expect(mail_gun_client).to receive(:send_message).with("sandbox_domain_name_for_your_account.mailgun.org", params)
    described_class.call(user)
  end
end