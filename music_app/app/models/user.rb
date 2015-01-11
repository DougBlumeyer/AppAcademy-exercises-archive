class User < ActiveRecord::Base
  attr_reader :password #i didn't think to put this here

  validates :email, :password_digest, :session_token, presence: true
  validates :email, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true } #i was missing this

  after_initialize :ensure_session_token

  has_many :notes

  def self.generate_token
    #SecureRandom.base64 i left off the urlsafe part
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    #session[:session_token] = self.generate_session_token #this was my first try
    self.session_token = User.generate_token #they prefer self.class.
    self.save! #i couldn't figure this out
    self.session_token #i couldn't figure this out
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    #BCrypt::Password.create(password).is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    #i couldn't figure this one out at all
    user = User.find_by_email(email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private
  def ensure_session_token #i failed to make this private
    #self.session_token = User.generate_session_token #this is what i had
    self.session_token ||= self.class.generate_token
  end
end
