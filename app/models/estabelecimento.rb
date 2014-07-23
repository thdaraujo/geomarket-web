class Estabelecimento < ActiveRecord::Base
  # Table relationship
  has_many :propagandas
  
  # Attributes
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  validates :nome, :presence => true, :uniqueness => true, :length => { :in => 3..50 }
  validates :logradouro, :presence => true, :uniqueness => false, :length => { :in => 3..50 }
  validates :numero, :presence => true, :uniqueness => false, :length => { :in => 3..15 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  
  validates :password, :presence => true, :length => { :in => 6..20 }, :confirmation => true, :on => :create
  
  # Methods
  before_save :encrypt_password
  after_save :clear_password
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.hashsenha= BCrypt::Engine.hash_secret(password, salt)
    end
  end
  def clear_password
    self.password = nil
  end
end
