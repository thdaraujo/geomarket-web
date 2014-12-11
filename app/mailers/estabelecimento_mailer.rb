class EstabelecimentoMailer < ActionMailer::Base
  default from: "geomarketapp@gmail.com"
    
  def forgot_password_email(estabelecimento, new_password)
    @estabelecimento = estabelecimento
    @new_password = new_password
    mail(to: @estabelecimento.email, subject: 'Nova senha do Geomarket!')
  end
end
