class Estabelecimento < ActiveRecord::Base
  # Table relationship
  has_many :propagandas
  
  # Attributes
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  validates :nome, :presence => true, :uniqueness => true, :length => { :in => 3..50 }
  validates :logradouro, :presence => true, :uniqueness => false, :length => { :in => 3..50 }
  validates :numero, :presence => true, :uniqueness => false
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
  
  def self.authenticate(username_or_email="", login_password="")
    if  EMAIL_REGEX.match(username_or_email)    
      estabelecimento = Estabelecimento.find_by_email(username_or_email)
    else
      estabelecimento = Estabelecimento.find_by_nome(username_or_email)
    end
    if estabelecimento && estabelecimento.match_password(login_password)
      return estabelecimento
    else
      return false
    end
  end   
  def match_password(login_password="")
    hashsenha == BCrypt::Engine.hash_secret(login_password, salt)
  end
end
