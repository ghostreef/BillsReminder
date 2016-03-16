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

ActiveRecord::Schema.define(version: 20160316152223) do

  create_table "bills", force: :cascade do |t|
    t.string   "issuer",      limit: 255
    t.string   "bill_type",   limit: 255
    t.decimal  "amount",                    precision: 8, scale: 2
    t.date     "due_date"
    t.text     "description", limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "paid"
    t.boolean  "auto_pay"
    t.integer  "term_unit",   limit: 4
    t.integer  "term_number", limit: 4
    t.boolean  "last_bill"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "categories_purposes", id: false, force: :cascade do |t|
    t.integer "category_id", limit: 4, null: false
    t.integer "purpose_id",  limit: 4, null: false
  end

  create_table "categories_sources", id: false, force: :cascade do |t|
    t.integer "category_id", limit: 4, null: false
    t.integer "source_id",   limit: 4, null: false
  end

  create_table "parsers", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "status",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "search_order",   limit: 65535
    t.text     "expected_order", limit: 65535
  end

  create_table "parsers_transformations", id: false, force: :cascade do |t|
    t.integer "parser_id",         limit: 4, null: false
    t.integer "transformation_id", limit: 4, null: false
  end

  create_table "purposes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "regex",      limit: 255
    t.integer  "purpose_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "popularity", limit: 4
  end

  create_table "transactions", force: :cascade do |t|
    t.date     "date"
    t.decimal  "amount",                      precision: 8, scale: 2
    t.string   "raw_description", limit: 255
    t.string   "description",     limit: 255
    t.integer  "source_id",       limit: 4
    t.integer  "purpose_id",      limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "locality",        limit: 255
    t.string   "region",          limit: 255
  end

  add_index "transactions", ["purpose_id"], name: "index_transactions_on_purpose_id", using: :btree
  add_index "transactions", ["source_id"], name: "index_transactions_on_source_id", using: :btree

  create_table "transformations", force: :cascade do |t|
    t.string   "regex",             limit: 255
    t.string   "value",             limit: 255
    t.string   "derives",           limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "case_insensitive"
    t.integer  "set",               limit: 4
    t.integer  "transformation_id", limit: 4
    t.integer  "complexity",        limit: 4
  end

  add_foreign_key "transactions", "purposes"
  add_foreign_key "transactions", "sources"
end
