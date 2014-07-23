class EstabelecimentoController < ApplicationController
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
    render "new"
  end
  
  private
  def estab_params
    params.require(:estabelecimento).permit(:email, :hashsenha, :salt, :nome, :logradouro, :numero, :complemento, :password, :password_confirmation)
  end
end
