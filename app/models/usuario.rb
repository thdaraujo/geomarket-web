class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :tipo_propagandas
  has_and_belongs_to_many :propagandas
  has_many :tokens

  # Attributes
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
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
    @usuario_tokens = self.tokens
    @token = @usuario_tokens.find{|t| t.ativo}
    if @token.nil?
      @token = Token.new
      @token.token = SecureRandom.uuid
      @token.ativo = true
      @token.device_id = 0
      self.tokens.create(token: @token.token, ativo: @token.ativo, device_id: @token.device_id)
    end
    return @token
  end
end
