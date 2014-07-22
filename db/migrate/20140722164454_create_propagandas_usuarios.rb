class CreatePropagandasUsuarios < ActiveRecord::Migration
  def self.up
    create_table :propagandas_usuarios, :id => false do |t|
      t.integer :usuario_id
      t.integer :propaganda_id
      t.boolean :enviada
      t.boolean :gostou
    end

    add_index :propagandas_usuarios, [:usuario_id, :propaganda_id]
  end
  def self.down
    drop_table :propagandas_usuarios
  end
end
