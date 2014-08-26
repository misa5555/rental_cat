class AddBirthday < ActiveRecord::Migration
  def change
    add_column :cats, :birth_date, :datetime
  end
end
