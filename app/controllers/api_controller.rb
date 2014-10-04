class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json, :xml

  def login_usuario
    authorized_user_token = Usuario.authenticate(params[:username_or_email], params[:login_password])
    if authorized_user_token
      respond_to do |format|
        format.json { render json: { :data => { :user_token => authorized_user_token.token } }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { :data => { :errors => 'Login falhou' } }, status: :bad_request }
        end
    end
  end

  def registra_usuario
    @usuario = Usuario.new(user_params)
    if @usuario.save
      respond_to do |format|
        format.json { render json: { :data => 'Usuário criado com sucesso!' }, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => { :errors => @usuario.errors } }, status: :unprocessable_entity }
      end
    end
  end

  def propagandas_usuario
    errors = []
    @token = Token.find_by_token(params[:token])
    if @token
      @usuario = Usuario.find(@token.usuario_id)
      if @usuario
        @propagandas = @usuario.propagandas
      else
        errors.push('Usuario não encontrado')
      end
    else
      errors.push('Token não encontrado')
    end

    if errors.length > 0
      respond_to do |format|
        format.json { render json: { :data => {:errors => errors }}, status: :bad_request }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => {:propagandas => @propagandas }}, status: :ok }
      end
    end
  end

  def assina_estabelecimento
    errors = []
    message = ''
    if params[:estabelecimento_id]
      if Estabelecimento.exists?(params[:estabelecimento_id])
        @token = Token.find_by_token(params[:token])
        if @token && Usuario.exists?(@token.usuario_id  )
          @usuario = Usuario.find(@token.usuario_id)
          if @usuario
            @estabelecimento = Estabelecimento.find(params[:estabelecimento_id])
            if @estabelecimento
              if @usuario.estabelecimentos.include?(@estabelecimento)
                message = 'Assinatura já existe'
              else
                @usuario.estabelecimentos << @estabelecimento
                message = 'Assinatura feita com sucesso'
              end
            else
              errors.push('Estabelecimento não encontrado')
            end
          else
            errors.push('Usuario não encontrado')
          end
        else
          errors.push('Token não encontrado')
        end
      else
        errors.push('Estabelecimento não encontrado')
      end
    else
      errors.push('Parâmetro estabelecimento_id não encontrado')
    end

    if errors.length > 0
      respond_to do |format|
        format.json { render json: { :data => {:errors => errors }}, status: :bad_request }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => message }, status: :ok }
      end
    end
  end

  def remove_estabelecimento
    errors = []
    message = ''
    if params[:estabelecimento_id]
      if Estabelecimento.exists?(params[:estabelecimento_id])
        @token = Token.find_by_token(params[:token])
        if @token && Usuario.exists?(@token.usuario_id  )
          @usuario = Usuario.find(@token.usuario_id)
          if @usuario
            @estabelecimento = Estabelecimento.find(params[:estabelecimento_id])
            if @estabelecimento
              if @usuario.estabelecimentos.include?(@estabelecimento)
                @usuario.estabelecimentos.delete(@estabelecimento)
                message = 'Assinatura removida com sucesso'
              else
                message = 'Assinatura não existe'
              end
            else
              errors.push('Estabelecimento não encontrado')
            end
          else
            errors.push('Usuario não encontrado')
          end
        else
          errors.push('Token não encontrado')
        end
      else
        errors.push('Estabelecimento não encontrado')
      end
    else
      errors.push('Parâmetro estabelecimento_id não encontrado')
    end

    if errors.length > 0
      respond_to do |format|
        format.json { render json: { :data => {:errors => errors }}, status: :bad_request }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => message }, status: :ok }
      end
    end
  end

  private
  def user_params
    params.require(:usuario).permit(:email, :password, :password_confirmation)
  end
end

