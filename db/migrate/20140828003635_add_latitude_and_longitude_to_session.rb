class AddLatitudeAndLongitudeToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :latitude, :float
    add_column :sessions, :longitude, :float
  end
end
