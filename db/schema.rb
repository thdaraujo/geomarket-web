# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141030023539) do

  create_table "estabelecimentos", force: true do |t|
    t.string   "nome"
    t.string   "logradouro"
    t.string   "numero"
    t.string   "complemento"
    t.string   "email"
    t.string   "hashsenha"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "estab_token"
  end

  create_table "mensagems", force: true do |t|
    t.string   "recebida"
    t.string   "enviada"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "propagandas", force: true do |t|
    t.string   "titulo"
    t.string   "corpo"
    t.string   "link"
    t.datetime "dataInicio"
    t.datetime "dataFim"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estabelecimento_id"
    t.integer  "tipo_propaganda_id"
  end

  create_table "propagandas_usuarios", id: false, force: true do |t|
    t.integer "usuario_id"
    t.integer "propaganda_id"
    t.boolean "enviada"
    t.boolean "gostou"
  end

  add_index "propagandas_usuarios", ["usuario_id", "propaganda_id"], name: "index_propagandas_usuarios_on_usuario_id_and_propaganda_id"

  create_table "tipo_propagandas", force: true do |t|
    t.string   "tipo"
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: true do |t|
    t.integer  "usuario_id"
    t.string   "token"
    t.integer  "device_id"
    t.boolean  "ativo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuario_preferencias", id: false, force: true do |t|
    t.integer "usuario_id"
    t.integer "tipo_propaganda_id"
  end

  add_index "usuario_preferencias", ["usuario_id", "tipo_propaganda_id"], name: "u_id_tp_prop_id_on_usuario_preferencias", unique: true

  create_table "usuarios", force: true do |t|
    t.string   "email"
    t.string   "hashsenha"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios_estabelecimentos", id: false, force: true do |t|
    t.integer "usuario_id"
    t.integer "estabelecimento_id"
  end

  add_index "usuarios_estabelecimentos", ["usuario_id", "estabelecimento_id"], name: "usuario_estabelecimento", unique: true

end
