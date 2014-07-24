class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
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
end
