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

ActiveRecord::Schema.define(version: 20140527022142) do

  create_table "cards", force: true do |t|
    t.string   "card_number"
    t.string   "name"
    t.string   "name_yomi"
    t.integer  "card_rare"
    t.integer  "card_kind"
    t.integer  "card_type"
    t.integer  "card_color"
    t.integer  "card_level"
    t.string   "grow_cost"
    t.string   "card_cost"
    t.integer  "card_limit"
    t.integer  "card_power"
    t.string   "condition"
    t.integer  "guard"
    t.text     "card_text"
    t.text     "life_burst"
    t.text     "view_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
