# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :email, :session_token, presence: true
  validates :email, :session_token, uniqueness: true
  validates :password_digest,
    presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many(:moderated_subs, class_name: "Sub", foreign_key: :moderator_id)
  has_many :posts, foreign_key: :author_id

  attr_reader :password

  after_initialize :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  # def password_digest
  #   # BCrypt::Password.new()
  # end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    @user = User.find_by_email(email)
    return nil if @user.nil?
    @user.is_password?(password) ? @user : nil
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
