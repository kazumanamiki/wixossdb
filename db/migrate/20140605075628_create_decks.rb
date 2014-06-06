class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.integer :user_id
      t.string :name
      t.string :desc
      t.text :card_data

      t.timestamps
    end
  end
end
