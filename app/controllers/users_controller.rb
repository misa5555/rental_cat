class UsersController < ApplicationController
  
  before_action :require_current_user!, except: [ :create, :new ]
  
  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
   
  def require_current_user!
    user = User.find(params[:id])
    
    if user.nil?
      nil
    elsif current_user.id != user.id
      flash[:errors] = [ "Permission Denied!" ]
      redirect_to root_url
    end
  end
end