class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json, :xml

  def index
    @test = 'Weeee'
    respond_with @test
  end

  def user_login
    authorized_user_token = Usuario.authenticate(params[:username_or_email], params[:login_password])
    if authorized_user_token
      respond_to do |format|
        format.json { render json: { :data => { :user_token => authorized_user_token } }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: { :data => { :errors => 'Login falhou' } }, status: :bad_request }
        end
    end
  end

  def user_register
    @usuario = Usuario.new(user_params)
    if @usuario.save
      respond_to do |format|
        format.json { render json: 'Usuário criado com sucesso!', status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { :data => { :errors => @usuario.errors } }, status: :unprocessable_entity }
      end
    end
  end

  private
  def user_params
    params.require(:usuario).permit(:email, :password, :password_confirmation)
  end
end

