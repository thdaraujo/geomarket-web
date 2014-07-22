class CreateTipoPropagandas < ActiveRecord::Migration
  def change
    create_table :tipo_propagandas do |t|
      t.string :tipo
      t.string :descricao

      t.timestamps
    end
  end
end
