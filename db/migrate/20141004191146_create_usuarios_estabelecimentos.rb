class CreateUsuariosEstabelecimentos < ActiveRecord::Migration
  def change
    create_table :usuarios_estabelecimentos, :id => false do |t|
      t.integer :usuario_id
      t.integer :estabelecimento_id
    end

    add_index(:usuarios_estabelecimentos, [:usuario_id, :estabelecimento_id], :unique => true, :name => :usuario_estabelecimento)
  end

  def self.down
    drop_table :estabelecimento_id
  end
end
