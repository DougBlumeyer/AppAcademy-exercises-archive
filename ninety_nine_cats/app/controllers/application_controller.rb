class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user,
    :logged_in?,
    :require_correct_user!,
    :current_user_id,
    :validate_user_owns_cat,
    :user_owns_cat?

  def login!(user)
    @current_user = user
    @current_user.try(:reset_session_token!)
    session[:session_token] = user.session_token
  end

  def logout!
    #@current_user.try(:reset_session_token!)
    if !SessionToken.find_by_session_token(session[:session_token]).nil?
      SessionToken.find_by_session_token(session[:session_token]).delete
    end
    session[:session_token] = nil
  end

  def current_user
    return nil if session[:session_token].nil?
    #@current_user ||= User.find_by_session_token(session[:session_token])
    if !SessionToken.find_by_session_token(session[:session_token]).nil?
      @current_user ||= User.find(SessionToken.find_by_session_token(session[:session_token]).user_id)
    else
      nil
    end
  end

  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end

  def require_correct_user!
    redirect_to cats_url if current_user.id != params[:id].to_i
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user_id
    return nil unless current_user
    User.find_by_session_token(session[:session_token]).id
  end

  def validate_user_owns_cat
    redirect_to cats_url unless user_owns_cat?
  end

  def user_owns_cat?
    @cat = Cat.find(params[:id])
    @cat.user_id == current_user_id
  end

end
