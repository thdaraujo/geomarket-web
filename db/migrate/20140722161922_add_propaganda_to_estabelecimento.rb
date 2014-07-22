class AddPropagandaToEstabelecimento < ActiveRecord::Migration
  def change
    add_column :propagandas, :estabelecimento_id, :integer
  end
end
