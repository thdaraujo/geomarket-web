class PropagandaController < ApplicationController  
  
  before_filter :authenticate_user
  
  def new
    @propaganda = Propaganda.new
  end

  def create
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @propaganda = @estabelecimento.propagandas.build(propaganda_params)
    @propaganda.tipo_propaganda_id = 2
    if @propaganda.save
      flash[:notice] = "Propaganda criada com sucesso!"
      flash[:color]= "valid"
      redirect_to(:controller => "Estabelecimento", :action => "home")
    else
      flash[:notice] = "Não foi possível criar a propaganda. =("
      flash[:color]= "invalid"
      render "new"
    end
  end

  def update
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @propaganda = @estabelecimento.propagandas.find(params[:id])
    @tipo = @propaganda.tipo_propagandas
  end

  def delete
  end

  def index
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @propagandas = @estabelecimento.propagandas
  end

  def show
    @estabelecimento = Estabelecimento.find(session[:user_id])
    @propaganda = @estabelecimento.propagandas.find(params[:id])
    @tipo = @propaganda.tipo_propagandas
  end
  
  private
  def propaganda_params
    params.require(:propaganda).permit!
  end
end
