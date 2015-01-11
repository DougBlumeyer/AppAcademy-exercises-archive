class AddSessionTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :session_token, :string
    add_index :users, :session_token, unique: true

    User.all.each do |user|
      user.reset_session_token!
    end

    change_column :users, :session_token, :string, null: false
  end
end
