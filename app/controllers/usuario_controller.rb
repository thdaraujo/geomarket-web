class UsuarioController < ApplicationController
  def new
    @usuario = Usuario.new 
  end
  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      flash[:notice] = "Cadastro efetuado com sucesso!"
      flash[:color]= "valid"
    else
      flash[:notice] = "Parâmetros inválidos."
      flash[:color]= "invalid"
    end
    render "new"
  end
  
  private
    def usuario_params
      params.require(:usuario).permit!
    end
end
