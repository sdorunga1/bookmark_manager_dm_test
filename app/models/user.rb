require 'bcrypt'

class User
  include DataMapper::Resource
  attr_reader :password
  attr_accessor :password_confirmation

  property :id, Serial
  property :email, String, required: true, unique: true

  property :password_digest, Text
  property :token, Text
  property :password_token_time, DateTime


  validates_confirmation_of :password
  validates_format_of :email, as: :email_address

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_token=(value)
    self.token = value
    self.password_token_time = DateTime.now
  end

  def self.authenticate(email, password)
    user = User.first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def self.find_by_token(token)
    user = first(token: token)
    if (user && user.password_token_time.to_time + (60 * 60) > Time.now)
      return user
    end
  end
end
