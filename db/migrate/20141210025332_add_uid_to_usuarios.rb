class AddUidToUsuarios < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :uid, :string, :unique => true
        Usuario.all.each do |usuario|
            usuario.uid = SecureRandom.hex(16)
            usuario.save()
        end
  end
  def self.down
    remove_column :usuarios, :uid
  end
end
