class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :tipo_propagandas
  has_and_belongs_to_many :propagandas

  # Attributes
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  validates :password, :presence => true, :length => { :in => 6..20 }, :confirmation => true, :on => :create

  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX

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
      usuario = Usuario.find_by_email(username_or_email)
    end
    if usuario && usuario.match_password(login_password)
      return usuario.get_token()
    else
      return false
    end
  end
  def match_password(login_password="")
    hashsenha == BCrypt::Engine.hash_secret(login_password, salt)
  end

  def get_token
    #TODO: Adicionar tabela de Tokens, relacionar ao Usuário e devolver um token neste método
    return 'asdkansdjnasdnasodna232131n2j3n1o23noac90m9ng94n23'
  end
end
