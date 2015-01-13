class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :private, default: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
    add_index :goals, :user_id
    add_index :goals, [:title, :user_id], unique: true
  end
end
