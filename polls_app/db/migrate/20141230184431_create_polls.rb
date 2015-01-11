class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, unique: true
      t.integer :author_id, null: false

      t.timestamps null: false
    end

    add_index :polls, :title
    add_index :polls, :author_id
  end
end
