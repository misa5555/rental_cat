class CatRentalRequestsController < ApplicationController
  
  def index
    @requests = CatRentalRequest.all
  end
  
  def show
    @request = CatRentalRequest.find(params[:id])
    render :show
  end
  
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end
  
  def create
    @request = CatRentalRequest.new(request_params)
    @cats = Cat.all
    
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
  def request_params
    params.require(:cat_rental_request).permit(
      :cat_id, :start_date, :end_date, :status
    )
  end
end
