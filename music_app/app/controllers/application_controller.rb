class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?
  helper_method :current_user
  helper_method :no_logged_out_user!#i had to go to my notes to remember why
  #it was still saying undefined method before i put this in

  def logged_in?
    #puts !@current_user.nil?
    !current_user.nil?
  end

  def current_user
    #true
    #User.find_by_session_token(session[:session_token]) this is all i had
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def log_in_user!(user)
    # @current_user = user
    # @current_user.try(:reset_session_token!)
    # session[:session_token] = user.session_token
    session[:session_token] = user.reset_session_token!
  end

  def log_out_user!
    @current_user.try(:reset_session_token!) #i couldn't come up with this part
    session[:session_token] = nil
  end

  def no_logged_out_user!
    unless logged_in?
      flash.now[:errors] = ["Must be logged out to view that page."]
      redirect_to new_user_url
    end
  end
end
