# todo

require 'timecop'

feature 'Resetting Password' do
  scenario 'When I forget my password I can see a link to reset' do
    visit '/sessions/new'
    click_link 'I forgot my password'
    expect(page).to have_content("Please enter your email address")
    expect(current_path).to eq "/users/recover"
  end

  scenario 'When I enter my email I am told to check my inbox' do
    recover_password
    expect(page).to have_content "Thanks, Please check your inbox for the link."
  end

  scenario 'assigned a reset token to the user when they recover' do
    sign_up
    expect{recover_password}.to change{User.first.token}
  end

  scenario 'it sets the time the password was saved' do
    sign_up
    Timecop.freeze do
      recover_password
      expect(User.first.password_token_time).to be_within(1).of DateTime.now
    end
  end

  scenario 'it doesn\'t allow you to use the token after an hour' do
    sign_up
    recover_password
    Timecop.travel(60 * 60 * 60)
    visit("/users/reset_password?token=#{User.first.token}")
    expect(page).to have_content "Your token is invalid"
  end

  scenario 'it redirects you to a new password page when your token is valid' do
    sign_up
    recover_password
    visit("/users/reset_password?token=#{User.first.token}")
    expect(page).to have_content("Please enter your new password")
  end

  def recover_password
    visit '/users/recover'
    fill_in :email, with: "alice@example.com"
    click_button "Submit"
  end


end
