class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :tipo_propagandas
  has_and_belongs_to_many :propagandas
end
