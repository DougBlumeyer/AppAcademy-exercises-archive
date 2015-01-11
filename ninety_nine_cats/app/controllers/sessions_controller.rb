class SessionsController < ApplicationController
  before_action :no_login_if_logged_in, only: [:new]

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render :new
    else
      login!(user)
      #redirect_to user_url(user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  def new
    render :new
  end

  private

  def no_login_if_logged_in
    redirect_to cats_url if logged_in?
  end

end
