class CreateCreateSessionsTables < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_token
      t.string :ip_address
      t.string :location
      t.integer :user_id

      t.timestamps
    end
    
    add_index :sessions, :session_token
    add_index :sessions, :user_id
  end
end
