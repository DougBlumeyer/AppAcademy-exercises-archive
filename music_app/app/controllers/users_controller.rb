class UsersController < ApplicationController
  def new
    @user = User.new #i had left this off, though i hadn't gotten to update yet so whatever
    render :new
  end

  def create
    @user = User.new(user_params)
    @user.activation_token = User.generate_token
    if @user.save

      msg = UserMailer.welcome_email(@user)
      msg.deliver
      # log_in_user!(@user)
      # redirect_to bands_url
      redirect_to activation_sent_static_pages_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = current_user
  end

  def activate
    @user = User.find_by_activation_token(params[:activation_token])
    if @user.nil?
      flash[:errors] = ["Invalid activation"]
      redirect_to new_session_url
    else
      flash[:notice] = ["Valid activation, welcome!"]
      @user.activated = true
      log_in_user!(@user)
      redirect_to bands_url
    end
  end

  def adminify
    @user = User.find(params[:id])
    @user.admin = true
    @user.save!
    redirect_to users_url
  end

  def disadminify
    @user = User.find(params[:id])
    @user.admin = false
    @user.save!
    redirect_to users_url
  end

  def index
    redirect_to bands_url unless current_user.admin
    @users = User.all
  end

  private

  def user_params
    params.require(:user)
      .permit(:email, :password)
      #.permit(:email, :session_token, :password, :password_digest)
      #maybe i was permitting too much?
      #yes, just what comes in through the form.
  end
end
