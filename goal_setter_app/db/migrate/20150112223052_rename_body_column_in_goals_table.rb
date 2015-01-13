class RenameBodyColumnInGoalsTable < ActiveRecord::Migration
  def change
    rename_column :goals, :body, :description
  end
end
