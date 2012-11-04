class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :facebook_uid

  before_save :encrypt_password
  validates :name, :email, :password, :presence=>true
  validates_uniqueness_of :email
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  def before_connect(facebook_session)
    self.name = facebook_session.first_name+" "+facebook_session.last_name
    self.email = facebook_session.email
    self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{facebook_session.first_name}.#{facebook_session.last_name}--")
  end

  def self.human_attribute_name(attr, options={})
    {
      :name => "Name",
      :email => "Email"
    }[attr.to_sym] || super
  end
  
  def valid_password? entered_password
    Authlogic::CryptoProviders::BCrypt.matches?(self.password, entered_password)
  end
  
  #before save
  def encrypt_password
    self.password = Authlogic::CryptoProviders::BCrypt.encrypt(self.password) unless self.password[0,4].to_s == "$2a$"
  end

end
