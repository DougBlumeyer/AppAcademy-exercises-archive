class AddCategory < ActiveRecord::Migration
  def change
    add_column :tracks, :category, :string
    change_column :tracks, :category, :string, null: false
  end
end
