class ForgotAlbumsBandIdColumn < ActiveRecord::Migration
  def change
    add_column :albums, :band_id, :integer
    change_column :albums, :band_id, :integer, null: false
    add_index :albums, :band_id
  end
end
