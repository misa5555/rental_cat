class AddCityZipcodeCountryToSession < ActiveRecord::Migration
  def change
    remove_column :sessions, :location
    add_column :sessions, :city, :string
    add_column :sessions, :zipcode, :string
    add_column :sessions, :country, :string
  end
end
