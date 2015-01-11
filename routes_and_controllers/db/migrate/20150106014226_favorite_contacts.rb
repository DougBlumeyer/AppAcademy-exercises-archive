class FavoriteContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :favorite, :integer
    change_column :contacts, :favorite, :integer, null: false
  end
end
