class CatRentalRequestsController < ApplicationController
  before_action :require_login!, only: [ :approve, :deny ]
  before_action :require_owner!, only: [ :approve, :deny ]
  
  
  def index
    @requests = CatRentalRequest.all
  end
  
  def show
    @request = CatRentalRequest.find(params[:id])
    @cat = @request.cat
    render :show
  end
  
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
    @cat_id = params[:cat_id]
  end
  
  def create
    @request = CatRentalRequest.new(request_params)
    @cats = Cat.all
    
    @request.user_id = current_user.id
    if @request.save!
      redirect_to cat_rental_request_url(@request)
    else
      render :new
    end
  end    
  
  def edit
    @request = CatRentalRequest.find(params[:id])
    @cats = Cat.all
    render :edit
  end
  
  def approve
    @request = CatRentalRequest.find(params[:id])
    
    if @request.approve!
      redirect_to cat_rental_request_url(@request)
    else
      render :index
    end
  end
  
  def deny
    @request = CatRentalRequest.find(params[:id])
    
    if @request.deny!
      redirect_to cat_rental_request_url(@request)
    else
      render :index
    end
  end    
  
  private
   
  def require_owner!
    request = CatRentalRequest.find(params[:id])
    
    if current_user.id != request.cat.owner.id
      flash[:errors] = [ "You must be the owner to approve/deny!" ]
      redirect_to cat_url(request.cat)
    end
  end
  
  def request_params
    params.require(:cat_rental_request).permit(
      :cat_id, :start_date, :end_date, :status
    )
  end
end
