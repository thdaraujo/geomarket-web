class CreatePropagandas < ActiveRecord::Migration
  def change
    create_table :propagandas do |t|
      t.string :titulo
      t.string :corpo
      t.string :link
      t.datetime :dataInicio
      t.datetime :dataFim

      t.timestamps
    end
  end
end
