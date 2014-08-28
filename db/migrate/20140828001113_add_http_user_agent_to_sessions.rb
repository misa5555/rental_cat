class AddHttpUserAgentToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :http_user_agent, :string
  end
end
