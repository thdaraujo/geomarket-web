class UsuarioPreferencias < ActiveRecord::Migration
  def self.up
    create_table :usuario_preferencias, :id => false do |t|
      t.integer :usuario_id
      t.integer :tipo_propaganda_id
    end

    add_index :usuario_preferencias, [:usuario_id, :tipo_propaganda_id], 
    :unique => true, :name => 'u_id_tp_prop_id_on_usuario_preferencias'
  end

  def self.down
    drop_table :usuario_preferencias
  end
end
