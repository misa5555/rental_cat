class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  
  helper_method :current_user

  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil    
  end 
   
  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
  
  def require_login!
    if current_user.nil?
      flash[:errors] = [ "You must be logged in to do that!" ]
      redirect_to new_session_url
    end
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
