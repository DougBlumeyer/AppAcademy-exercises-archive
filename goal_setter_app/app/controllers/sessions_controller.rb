class SessionsController < ApplicationController
  before_action :only_logged_out!, except: :destroy
  before_action :only_logged_in!, only: :destroy

  def new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user.nil?
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    else
      flash[:notices] = ["Welcome back, #{@user.username}!"]
      login!(@user)
      redirect_to user_url(@user)
    end
  end

  def destroy
    #@user = User.find(params[:id])
    #@user.destroy
    logout!
    redirect_to new_session_url
  end
end
