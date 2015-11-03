describe User do

 let!(:user) do
   User.create(email: 'test@test.com', password: 'secret1234',
               password_confirmation: 'secret1234')
 end

 it 'authenticates when given a valid email address and password' do
   authenticated_user = User.authenticate(user.email, user.password)
   expect(authenticated_user).to eq user
 end

  it 'does not authenticate when given an incorrect password' do
    expect(User.authenticate(user.email, 'wrong_stupid_password')).to be_nil
  end

  it 'can find a user with a valid token' do
    user.password_token = "token"
    user.save
    expect(User.find_by_token("token")).to eq user
  end

  it 'can\'t find a user with a token over 1 hour in the future' do
    user.password_token = "token"
    user.save
    Timecop.travel(60 * 60 + 1) do
     expect(User.find_by_token("token")).to eq nil
    end
  end
end
