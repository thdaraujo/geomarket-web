class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json, :xml

  def initialize
    @NUMERO_PROPAGANDAS = 6
  end

  def login_usuario
    authorized_user_token = Usuario.authenticate(params[:uid], params[:password])
    if authorized_user_token
      respond_to do |format|
        format.json { render json: { :user_token => authorized_user_token.token }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { :errors => 'Login falhou' }, status: :bad_request }
        end
    end
  end

  def registra_usuario
    @usuario = Usuario.new(user_params)
    if @usuario.save
      respond_to do |format|
        format.json { render json: { :user_uid => @usuario.uid }, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { :errors => @usuario.errors }, status: :unprocessable_entity }
      end
    end
  end

  def assina_estabelecimento
    errors = []
    message = ''
    if params[:estab_token]
      if Estabelecimento.exists?(:estab_token => params[:estab_token])
        @token = Token.find_by_token(params[:token])
        if @token && Usuario.exists?(@token.usuario_id  )
          @usuario = Usuario.find(@token.usuario_id)
          if @usuario
            @estabelecimento = Estabelecimento.find_by_estab_token(params[:estab_token])
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
      errors.push('Parâmetro estab_token não encontrado')
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
    if params[:estab_token]
      if Estabelecimento.exists?(:estab_token => params[:estab_token])
        @token = Token.find_by_token(params[:token])
        if @token && Usuario.exists?(@token.usuario_id  )
          @usuario = Usuario.find(@token.usuario_id)
          if @usuario
            @estabelecimento = Estabelecimento.find_by_estab_token(params[:estab_token])
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

  def avalia_propaganda
    errors = []
    if params[:propaganda_id]
      if params[:gostou]
        if Propaganda.exists?(params[:propaganda_id])
          @token = Token.find_by_token(params[:token])
          if @token
            @usuario = Usuario.find(@token.usuario_id)
            if @usuario
              @propaganda = Propaganda.find(params[:propaganda_id])
              @propaganda_usuario = @usuario.propagandas_usuarios.all.select{|up| up.propaganda_id == @propaganda.id}.first
              if @propaganda_usuario
                @propaganda_usuario.gostou = params[:gostou]
                @propaganda_usuario.save
              else
                #@usuario.propagandas << Propaganda.find(1)
                errors.push('A propaganda não foi encontrada para esse usuário')
              end
            else
              errors.push('Usuario não encontrado')
            end
          else
            errors.push('Token não encontrado')
          end
        else
          errors.push('Propaganda não existe')
        end
      else
        errors.push('Parâmetro gostou não encontrado')
      end
    else
      errors.push('Parâmetro propaganda_id não encontrado')
    end

    #Return
    if errors.length > 0
      respond_to do |format|
        format.json { render json: { :data => {:errors => errors }}, status: :bad_request }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => {:propaganda_usuario => @propaganda_usuario }}, status: :ok }
      end
    end
  end

  def propagandas_usuario
    errors = []
    @data = DateTime.now
    @token = Token.find_by_token(params[:token])
    if @token
      @usuario = Usuario.find(@token.usuario_id)
      if @usuario
        @prop_usuario = PropagandasUsuario.where(:usuario_id == @usuario.id)
        puts @prop_usuario.inspect
        @propagandas = @prop_usuario.collect{|pu| pu.propaganda if (pu.enviada == nil || pu.enviada == false) && pu.propaganda.dataFim > @data && pu.propaganda.dataInicio < @data
           }.compact
        puts 'propagandas'
        puts @propagandas.inspect
        if @propagandas.size < @NUMERO_PROPAGANDAS
          # Seleciona NUMERO_PROPAGANDAS propagandas dos estabelecimentos cadastrados do usuário
          @u_prop_id = @usuario.propagandas.collect(&:id)
          @novas_propagandas = []
          # Filtra as propagandas dos estabelecimentos aos quais o usuário está registrado, buscando somente
          # as que ainda não estiverem relacionadas a ele e que estejam dentro da "validade".
          @usuario.estabelecimentos.each do |estab|
            estab.propagandas.each do |n_prop|
              if n_prop.dataInicio < @data && n_prop.dataFim > @data && !@u_prop_id.include?(n_prop.id)
                @novas_propagandas << n_prop
                @usuario.propagandas << n_prop
                puts 'Adicionou novas propagandas'
              end
            end
          end
          @propagandas.concat @novas_propagandas
          @propagandas = @propagandas.take(@NUMERO_PROPAGANDAS)
          @pus = PropagandasUsuario.where(:usuario_id == @usuario.id, @propagandas.map(&:id).include?(:propaganda_id))
          @pus.update_all "enviada = 'true'"
        end
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
        format.json { render json: { :propagandas => @propagandas }, status: :ok }
      end
    end
  end

  def teste
    @teste = params[:teste]
    respond_to do |format|
      format.json { render json: { :data => @teste, :max_props => @NUMERO_PROPAGANDAS }, status: :ok }
    end
  end

  private
  def user_params
    params.require(:usuario).permit(:email, :password, :password_confirmation)
  end
end
