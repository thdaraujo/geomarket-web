class EstabelecimentoController < ApplicationController
  
  before_filter :authenticate_user, :only => [:home, :profile, :settings]
  before_filter :check_login_state, :only => [:new, :create, :login, :login_attempt]
  
  def new
    @estabelecimento = Estabelecimento.new 
  end
  def create
    @estabelecimento = Estabelecimento.new(estab_params)
    if @estabelecimento.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
    render "login"
  end
  
  def login
    #Login form
  end
  
  def login_attempt
    authorized_user = Estabelecimento.authenticate(params[:username_or_email], params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:info] = "Bem vindo, #{authorized_user.nome}"
      redirect_to(:action => "home")
    else
      flash[:error] = "Nome de usuário ou senha inválidos."
      render "login"
    end
  end
  
  def home
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "Sessão finalizada com sucesso!"
    redirect_to(:controller => "Home", :action => "index")
  end
  
  private
  def estab_params
    params.require(:estabelecimento).permit(:email, :hashsenha, :salt, :nome, :logradouro, :numero, :complemento, :password, :password_confirmation)
  end
end
