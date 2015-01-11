class Polltitlecantbenull < ActiveRecord::Migration
  def change
    change_column :polls, :title, :string, null:false
  end
end
