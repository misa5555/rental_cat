class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.integer :age 
      t.timestamps :birth_date
      t.string :color
      t.string :name, null: false
      t.string :sex
      t.text :description
      
      t.timestamps
    end
  end
end
