class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :usuario_id
      t.string :token
      t.integer :device_id
      t.boolean :ativo

      t.timestamps
    end
  end
end
