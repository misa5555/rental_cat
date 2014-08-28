class Session < ActiveRecord::Base
  belongs_to :user
  
  validates :session_token, presence: true
  after_initialize :ensure_session_token
  
  geocoded_by :ip_address do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zipcode = geo.postal_code
      obj.country = geo.country_code
    end
  end
  after_validation :geocode
  
  def self.find_by_session_token(token)
    return nil if token.nil?
    self.find_by(session_token: token)
  end  
  
  def self.generate_session_token
     SecureRandom::urlsafe_base64(16)
  end
  
  def address
    "#{self.city}, #{self.zipcode}, #{self.country}"
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
