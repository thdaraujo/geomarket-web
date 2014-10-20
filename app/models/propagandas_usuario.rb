class PropagandasUsuario < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :propaganda
end
