class CreateMensagems < ActiveRecord::Migration
  def change
    create_table :mensagems do |t|
      t.string :recebida
      t.string :enviada

      t.timestamps
    end
  end
end
