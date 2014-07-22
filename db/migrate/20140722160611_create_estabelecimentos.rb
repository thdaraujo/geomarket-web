class CreateEstabelecimentos < ActiveRecord::Migration
  def change
    create_table :estabelecimentos do |t|
      t.string :nome
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.string :email
      t.string :hashsenha
      t.string :salt

      t.timestamps
    end
  end
end
