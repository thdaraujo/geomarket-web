class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = :pt
  end
  protected
  def authenticate_user
    if session[:user_id]
      @current_user = Estabelecimento.find(session[:user_id])
      return true
    else
      redirect_to(:controller => "Estabelecimento", :action => "login")
      return false
    end
  end
  def check_login_state
    if session[:user_id]
      redirect_to(:controller => "Estabelecimento", :action => "home")
      return false
    else
      return true
    end
  end
  def check_user
    if session[:user_id]
      if !Estabelecimento.exists?(session[:user_id])
        session[:user_id] = nil
        redirect_to(:controller => "Home", :action => "index")
      else
        @current_user = Estabelecimento.find(session[:user_id])
      end
    end
    return true
  end
end
