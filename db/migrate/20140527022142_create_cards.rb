class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_number
      t.string :name
      t.string :name_yomi
      t.integer :card_rare
      t.integer :card_kind
      t.integer :card_type
      t.integer :card_color
      t.integer :card_level
      t.string :grow_cost
      t.string :card_cost
      t.integer :card_limit
      t.integer :card_power
      t.string :condition
      t.integer :guard
      t.text :card_text
      t.text :life_burst
      t.text :view_text

      t.timestamps
    end
  end
end
