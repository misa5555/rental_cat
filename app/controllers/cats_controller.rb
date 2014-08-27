class CatsController < ApplicationController
  before_action :require_login!, only: [ :new, :create, :edit, :update ]
  
  def index
    @cats = Cat.all
    render :index
  end
  
  def show
    @cat = Cat.find(params[:id])
    @requests = @cat.cat_rental_requests.sort_by { |r| r.start_date }
    
    render :show
  end
  
  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    
    if @cat.save
      flash[:notices] = [ "#{@cat.name} successfully registered!"]
      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat.errors.full_messages
      render :new
    end
  end
  
  def new
    @cat = Cat.new
  end  
  
  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end
  
  def update
    @cat = Cat.find(params[:id])
    
    if @cat.update!(cat_params)
      flash[:notices] = [ "#{@cat.name} successfully edited!"]
      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat.errors.full_messages
      render :edit
    end
  end  
  
  private
  def cat_params
    params.require(:cat).permit(
      :age, :birth_date, :color, :name, :sex, :description
    )
  end
end
