class Propaganda < ActiveRecord::Base
  belongs_to :estabelecimentos
  belongs_to :tipo_propagandas
  has_many :propagandas_usuarios
  has_many :usuarios, :through => :propagandas_usuarios
  
  validates :titulo, presence: true, length: { in: 2..50 }
  validates :corpo, presence: true, length: { in: 6..250 }
  validates :link, presence: true, length: { minimum: 6 }
  validates :dataInicio, presence: true
  validates :dataFim, presence: true
  
  validate :dataInicioNaoDeveEstarNoPassado
  validate :dataFimNaoDeveEstarNoPassado
  
  def dataInicioNaoDeveEstarNoPassado
    if dataInicio.present? && dataInicio < Date.today
      errors.add('Data de Início', 'não pode estar no passado.')
    end
  end
  
  def dataFimNaoDeveEstarNoPassado
    if dataFim.present? && dataInicio.present? && dataFim < dataInicio
      errors.add('Data de Início', 'não pode estar no passado e nem ser menor que a data de início.')
    end
  end
  
end
