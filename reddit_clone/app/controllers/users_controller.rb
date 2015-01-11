class UsersController < ApplicationController
  before_action :only_correct_user!, only: [:show]

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end


  private

  def user_params
    params.require(:user).permit(:email, :session_token, :password)
  end
end
