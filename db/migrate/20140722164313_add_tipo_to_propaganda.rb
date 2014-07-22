class AddTipoToPropaganda < ActiveRecord::Migration
  def change
    add_column :propagandas, :tipo_propaganda_id, :integer
  end
end
