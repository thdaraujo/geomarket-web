class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :tipo_propagandas
  has_many :propagandas_usuarios
  has_many :propagandas, :through => :propagandas_usuarios
  has_and_belongs_to_many :estabelecimentos, :join_table => :usuarios_estabelecimentos
  has_many :tokens

  # Attributes
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  validates :uid, :uniqueness => true
  validate :email, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :presence => true, :length => { :in => 6..20 }, :confirmation => true, :on => :create

  # Methods
  before_save :encrypt_password, :generate_uid
  after_save :clear_password

  def generate_uid
    self.uid = SecureRandom.hex(16)
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.hashsenha= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(uid="", password="")
    puts uid
    if uid
      usuario = Usuario.find_by_uid(uid)
    end
    if usuario && usuario.match_password(password)
      return usuario.get_token()
    else
      return false
    end
  end
  def match_password(password="")
    hashsenha == BCrypt::Engine.hash_secret(password, salt)
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
