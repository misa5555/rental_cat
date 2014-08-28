class SessionsController < ApplicationController
  before_action :already_logged_in?, only: [ :create ]
  
  before_action :require_login!, only: [ :index ]
  before_action :require_current_user!, 
    only: [ :index, :destroy, :logout_remote ]
  
  def index
    @sessions = Session.where(user_id: current_user.id)
    @sessions.reject! do |user_session|
      user_session.session_token == session[:session_token]
    end
  end  
  
  def create
    @session = Session.create(
      user_id: @user.id, 
      ip_address: request.remote_ip,
      http_user_agent: request.env["HTTP_USER_AGENT"]
    )
    
    if @user.nil?
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    else
      session[:session_token] = @session.session_token
      flash[:notices] = [ "Welcome back #{@user.username}!" ]
      redirect_to user_url(@user)
    end
  end

  def new
  end
  
  def destroy
    @user = current_user
    user_session = Session.find_by_session_token(session[:session_token])
    
    if user_session.destroy
      session[:session_token] = nil
      flash[:notices] = [ "#{@user.username} has logged out!"]
      redirect_to login_url
    else
      flash[:errors] = [ "There was an error!" ]
      redirect_to root_url
    end
  end
  
  def logout_remote
    session_target = Session.find(params[:id])
    
    if session_target.destroy
      flash[:notices] = [ "Logged out at #{session_target.ip_address}!"]
      redirect_to sessions_url
    else
      flash[:errors] = [ "There was an error!" ]
      redirect_to root_url
    end
  end  
  
  private
  
  def already_logged_in?
    user = logging_in_user
    
    user_session = Session.find_by_session_token(session[:session_token])
    
    unless user_session.nil?
      flash[:errors] = [ "You are already logged in at this location" ]
      redirect_to user_url(user)
    end
  end
  
  def logging_in_user
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
  end
  
  def require_current_user!
    user_session = Session.find_by_session_token(session[:session_token])

    unless user_session.user_id == current_user.id
      flash[:errors] = [ "Permission denied!" ]
      redirect_to root_url
    end
  end   
end
