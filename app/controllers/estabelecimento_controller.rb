class EstabelecimentoController < ApplicationController
  
  before_filter :authenticate_user, :only => [:home, :profile, :settings, :edit]
  before_filter :check_login_state, :only => [:new, :create, :login, :login_attempt, :forgot_password]
  
  def new
    @estabelecimento = Estabelecimento.new 
  end
  def create
    @estabelecimento = Estabelecimento.new(estab_params)
    if @estabelecimento.save
      flash[:notice] = 'Login efetuado!'
      flash[:color]= 'valid'
    else
      flash[:notice] = 'Não foi possível efetuar seu login'
      flash[:color]= 'invalid'
    end
    redirect_to(:action => 'login')
  end
  
  def login
    #Login form
  end
  
  def login_attempt
    authorized_user = Estabelecimento.authenticate(params[:username_or_email], params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:info] = 'Bem vindo, ' + authorized_user.nome.to_s
      redirect_to(:action => 'home')
    else
      flash[:error] = 'Nome de usuário ou senha inválidos.'
      render 'login'
    end
  end
  
  def home
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = 'Sessão finalizada com sucesso!'
    redirect_to(:controller => 'Home', :action => 'index')
  end
  
  def forgot_password
    #just for the view
  end
  
  def recover_password
    @email = params[:email] == nil ? '' : params[:email]
    @estabelecimento = Estabelecimento.find_by_email(@email)
    if @estabelecimento
      @password = SecureRandom.base64(9)[0..12]
      @estabelecimento.password = @password
      if @estabelecimento.save
        EstabelecimentoMailer.forgot_password_email(@estabelecimento, @password).deliver!
        render 'mail_sent'
      else
        flash[:info] = 'Falha ao gerar nova senha para o estabelecimento com o email ' + @email + '. Tente novamente ou entre em contato com a nossa equipe!'
        redirect_to(:action => 'forgot_password')
      end
    else
      flash[:info] = 'Não foi encontrado um estabelecimento com o email ' + @email
      redirect_to(:action => 'forgot_password')
    end
  end
  
  def mail_sent
    # just for the view
  end
  
  def edit
    @estabelecimento = Estabelecimento.find(session[:user_id])
  end
  
  def save_edits
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @estabelecimento.update(estab_params)
    if @estabelecimento.save
      flash[:success] = 'Informações alteradas com sucesso!'
    else
      flash[:error] = 'Não conseguimos atualizar suas informações. =('
    end
    redirect_to(:action => 'edit')
  end
  
  def change_password
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @old_pass = params[:old_pass]
    @new_pass = params[:new_pass]
    @new_pass_confirmation = params[:new_pass_confirmation]
    
    if @new_pass == @new_pass_confirmation && 8 < @new_pass.length && @new_pass.length < 99
      @estabelecimento.password = @new_pass
      if @estabelecimento.save
        flash[:success] = 'Senha alterada!'
      else
        flash[:error] = 'Não conseguimos alterar sua senha. =('
      end
    else
      flash[:error] = 'Parametros incorretos. =P'
    end
    redirect_to(:action => 'edit')
  end
  
  private
  def estab_params
    params.require(:estabelecimento).permit(:email, :hashsenha, :salt, :nome, :logradouro, :numero, :complemento, :password, :password_confirmation)
  end
end
