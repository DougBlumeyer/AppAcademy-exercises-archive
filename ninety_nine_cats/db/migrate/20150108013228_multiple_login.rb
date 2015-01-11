class MultipleLogin < ActiveRecord::Migration
  def change
    create_table :session_tokens do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.string :device, null: false

      t.timestamps null: false
    end

    add_index :session_tokens, :user_id
  end
end
