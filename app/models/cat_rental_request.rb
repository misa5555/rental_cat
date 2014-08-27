class CatRentalRequest < ActiveRecord::Base
  STATUSES = [
    "PENDING",
    "APPROVED",
    "DENIED"
  ]
  
  belongs_to :cat, dependent: :destroy
  
  before_validation :default_status
  
  validates :status, inclusion: { in: STATUSES }
  validates :cat_id, :start_date, :end_date, presence: true
  
  validate :no_approved_overlap
  
  def approve!
    self.status = "APPROVED"
    
    CatRentalRequest.transaction do 
      self.save!
      
      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
    
    self
  end
  
  def deny!
    self.status = "DENIED"
    self.save!
    
    self
  end
  
  def pending?
    self.status == "PENDING"
  end
  
  private
  
  def default_status
    self.status ||= "PENDING"
  end
  
  def no_approved_overlap
    overlaps = overlapping_approved_requests
    
    if self.status == 'APPROVED' && overlaps.any?
      errors[:cat_id] << "can not have overlapping rentals!"
    end
  end
  
  def overlapping_requests
    CatRentalRequest
      .select('cat_rental_requests.*')
      .joins(:cat)
      .where(<<-SQL, start_date, end_date, start_date, end_date)
          cat_rental_requests.start_date BETWEEN ? AND ?
        OR
          cat_rental_requests.end_date BETWEEN ? AND ?
        SQL
      .where("(:id IS NULL) OR (cat_rental_requests.id != :id)",
              id: self.id)
  end
  
  def overlapping_pending_requests
    overlapping_requests
      .where(status: "PENDING")
  end
  
  def overlapping_approved_requests
    overlapping_requests
      .where(status: 'APPROVED')
  end
  
end
