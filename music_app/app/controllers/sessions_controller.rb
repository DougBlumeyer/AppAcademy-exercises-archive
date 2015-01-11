class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    #should re-set the appropriate user's
    #session_token and session[:session_token].
    @user = User.find_by_credentials(
      params[:user][:email], ###ARGH, okay i wasn't deeply nesting enough
      params[:user][:password] ###I was leaving off the [:user] part
    )
    # fail
    if @user.nil?
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    else
      ######### I DIDN'T GET THIS YET
      log_in_user!(@user)
      #########
      #redirect_to user_url(@user)
      flash[:notice] = ["Welcome back!"]
      redirect_to bands_url
    end
  end

  def destroy
    log_out_user!
    flash[:notice] = ["See you again soon!"]
    redirect_to new_session_url
  end
end
