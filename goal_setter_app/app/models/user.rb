class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :session_token, presence: true
  validates :password_digest, presence: {message: "Password can't be blank, noooob!"}
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  has_many :goals, inverse_of: :user

  include Commentable

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(username, password)
    @user = User.find_by(username: username)
    return nil if @user.nil?
    @user.is_password?(password) ? @user : nil
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def completed_goals
    goals.select(&:completed)
  end

  def incomplete_goals
    goals.reject(&:completed)
  end

  private

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
