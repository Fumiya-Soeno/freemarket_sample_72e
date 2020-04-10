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

ActiveRecord::Schema.define(version: 20200409110923) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",     null: false
    t.string   "post_number", null: false
    t.string   "city",        null: false
    t.string   "address",     null: false
    t.string   "apartment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "prefecture"
    t.index ["user_id"], name: "index_addresses_on_user_id", using: :btree
  end

  create_table "blands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "company",    null: false
    t.string   "number",     null: false
    t.string   "cord",       null: false
    t.integer  "year",       null: false
    t.integer  "month",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "card_id"
    t.index ["user_id"], name: "index_cards_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conditions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evaluations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",    null: false
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "grin"
    t.integer  "meh"
    t.integer  "frown"
    t.index ["product_id"], name: "index_evaluations_on_product_id", using: :btree
    t.index ["user_id"], name: "index_evaluations_on_user_id", using: :btree
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image",      null: false
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_images_on_product_id", using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "number"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "product_blands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id", null: false
    t.integer  "bland_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bland_id"], name: "index_product_blands_on_bland_id", using: :btree
    t.index ["product_id"], name: "index_product_blands_on_product_id", using: :btree
  end

  create_table "product_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id",  null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id", using: :btree
    t.index ["product_id"], name: "index_product_categories_on_product_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "explanation",     limit: 65535,                 null: false
    t.string   "name",                                          null: false
    t.string   "region",                                        null: false
    t.string   "size"
    t.integer  "price",                                         null: false
    t.integer  "shipping_days",                                 null: false
    t.boolean  "postage",                       default: false, null: false
    t.integer  "user_id",                                       null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "condition_id",                                  null: false
    t.integer  "category_id",                                   null: false
    t.integer  "bland_id",                                      null: false
    t.string   "shipping_method"
    t.boolean  "soldout",                       default: false, null: false
    t.index ["bland_id"], name: "index_products_on_bland_id", using: :btree
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["condition_id"], name: "index_products_on_condition_id", using: :btree
    t.index ["user_id"], name: "index_products_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "birth_year",                          null: false
    t.integer  "birth_month",                         null: false
    t.integer  "birth_day",                           null: false
    t.string   "tel_number",                          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "password"
    t.string   "password_confirmation"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "firstname",                           null: false
    t.string   "lastname",                            null: false
    t.string   "firstname_kana",                      null: false
    t.string   "lastname_kana",                       null: false
    t.string   "email"
    t.string   "nickname",                            null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "cards", "users"
  add_foreign_key "evaluations", "products"
  add_foreign_key "evaluations", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "product_blands", "blands"
  add_foreign_key "product_blands", "products"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "products", "blands"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "conditions"
  add_foreign_key "products", "users"
end
