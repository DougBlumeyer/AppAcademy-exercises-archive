class ChangeTypeColumnNameToSomethingElse < ActiveRecord::Migration
  def change
    rename_column :albums, :type, :recording_type
  end
end
