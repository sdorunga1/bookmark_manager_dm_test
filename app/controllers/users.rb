class BookmarkManager < Sinatra::Base
  require 'securerandom'
  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end


  post '/users' do
    @user = User.new(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    # require 'byebug'; byebug
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/users/recover' do
    erb :'users/recover'
  end

  post '/users/recover' do
    user = User.first(email: params[:email])
    if user
      user.password_token = SecureRandom.hex
      user.save
    end
    erb :'users/acknowledgment'
  end

  get '/users/reset_password' do
    @user = User.find_by_token(params[:token])
    if(@user)
      "Please enter your new password"
    else
      "Your token is invalid"
    end
  end

end
