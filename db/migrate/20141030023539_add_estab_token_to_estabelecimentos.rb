class AddEstabTokenToEstabelecimentos < ActiveRecord::Migration
  def self.up
    add_column :estabelecimentos, :estab_token, :string, :unique => true
        Estabelecimento.all.each do |estabelecimento|
            estabelecimento.estab_token = SecureRandom.base64(9)[0..6]
            estabelecimento.save()
        end
  end
  def self.down
    remove_column :estabelecimentos, :estab_token
  end
end
