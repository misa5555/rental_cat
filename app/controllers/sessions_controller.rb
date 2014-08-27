class SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user.nil?
      flash.now[:errors] = @user.errors.full_messages
      render :new
    else
      login!(@user)
      flash[:notices] = [ "Welcome back #{@user.username}!" ]
      redirect_to user_url(@user)
    end
  end

  def new
  end
  def destroy
    logout!
    flash[:notices] = [ "#{@user} has logged out!"]
    redirect_to new_session_url
  end  
end
