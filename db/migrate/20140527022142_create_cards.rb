class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_number
      t.string :name
      t.string :name_yomi
      t.string :card_rare
      t.string :card_kind
      t.string :card_type
      t.string :card_color
      t.integer :card_level
      t.string :grow_cost
      t.string :card_cost
      t.integer :card_limit
      t.integer :card_power
      t.string :condition
      t.string :guard
      t.text :card_text
      t.text :life_burst
      t.text :view_text
      t.text :search_all_text

      t.timestamps
    end
  end
end
