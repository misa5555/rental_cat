class Cat < ActiveRecord::Base
  COLORS = [
    "white", "brown", "black", "blue", "calico", "tabby"
  ]
  
  validates_numericality_of :age, greater_than_or_equal_to: 0
  validates :sex, inclusion: { in: ["M", "F"]}
  validates :color, inclusion: { in: COLORS }
  
  before_validation :upcase_sex
  
  has_many :cat_rental_requests
  
  private
  def upcase_sex
    sex.upcase! unless sex.nil?
  end
end
