class User < ActiveRecord::Base
  attr_reader :password
  
  validates :username, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  
  validates :session_token, presence: true
  after_initialize :ensure_session_token
  
  has_many :cats
  has_many :cat_rental_requests
  
  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end
  
  def self.generate_session_token
     SecureRandom::urlsafe_base64(16)
  end 
  
  def password= password
    @password= password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password? password
    BCrypt::Password.new(password_digest).is_password? password
  end
  
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    # we must be sure to use the ||= operator instead of ||, otherwise
    # we will end up with a new session token every time we create
    # a new instance of the User class. This includes finding it in the DB!
    self.session_token ||= self.class.generate_session_token
  end
end
