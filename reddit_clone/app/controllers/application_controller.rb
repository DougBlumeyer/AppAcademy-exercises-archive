class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :login!,
    :logout,
    :current_user,
    :logged_in?

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def only_logged_out!
    redirect_to user_url(current_user) if logged_in?
  end

  def only_correct_user!
    redirect_to user_url(current_user) if current_user.id != params[:id].to_i
  end
end
