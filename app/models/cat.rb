class Cat < ActiveRecord::Base
  validates_numericality_of :age, greater_than_or_equal_to: 0
  validates :sex, inclusion: { in: ["M", "F"]}
end
