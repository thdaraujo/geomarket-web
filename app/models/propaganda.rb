class Propaganda < ActiveRecord::Base
  belongs_to :estabelecimentos
  belongs_to :tipo_propagandas
  has_and_belongs_to :usuarios
end
