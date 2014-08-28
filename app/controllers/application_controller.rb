class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  def current_user
    return nil if session[:session_token].nil?
  
    user_session = Session.find_by_session_token(session[:session_token])
    return nil if user_session.nil?
    
    @current_user ||= user_session.user
  end
  
  def require_login!
    if current_user.nil?
      flash[:errors] = [ "You must be logged in to do that!" ]
      redirect_to login_url
    end
  end
  
end
