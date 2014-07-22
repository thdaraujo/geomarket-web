class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :email
      t.string :hashsenha
      t.string :salt

      t.timestamps
    end
  end
end
