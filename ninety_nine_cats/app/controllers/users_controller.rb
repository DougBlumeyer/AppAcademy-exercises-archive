class UsersController < ApplicationController
  before_action :require_current_user!, except: [:create, :new]
  before_action :require_correct_user!, only: [:show]

  before_action :no_signup_if_logged_in, only: [:new]

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@current_user)
    else
      render json: @user.errors.full_messages
    end
  end

  def show
    if @current_user.nil?
      redirect_to new_session_url
      return
    end

    @user = current_user
    @cats = Cat.all.select { |cat| cat.user_id == current_user_id }
    render :show
  end

  def new
    @user = User.new
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def no_signup_if_logged_in
    redirect_to cats_url if logged_in?
  end
end
