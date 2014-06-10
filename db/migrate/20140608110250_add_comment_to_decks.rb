class AddCommentToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :comment, :text
  end
end
