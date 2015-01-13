class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user

  def login!(user)
    session[:token] = user.reset_session_token!
  end

  def logout!
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

  def logged_in?
    !!current_user
  end

  def only_logged_in!
    redirect_to new_session_url unless logged_in?
  end

  def only_logged_out!
    redirect_to user_url(current_user) if logged_in?
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:token])
  end
end
