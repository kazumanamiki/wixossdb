class AddIllustToCards < ActiveRecord::Migration
  def change
    add_column :cards, :illust_url, :text
    add_column :cards, :illustrator, :string
  end
end
