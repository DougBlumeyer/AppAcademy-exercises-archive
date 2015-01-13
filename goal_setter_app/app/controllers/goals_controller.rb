class GoalsController < ApplicationController
  before_action :protect_private_goals!, only: [:show]

  def new
  end

  def create
    @goal = current_user.goals.new(goal_params)
    if @goal.save
      flash[:notice] = ["New goal created successfully!"]
    else
      flash[:errors] = @goal.errors.full_messages
    end
    redirect_to user_url(current_user)
  end

  def show
    @goal = Goal.find(params[:id])
    render :show
  end

  def complete
    @goal = Goal.find(params[:id])
    @goal.completed = true
    @goal.save
    redirect_to goal_url(@goal)
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :description, :private, :completed)
  end

  def protect_private_goals!
    @goal = Goal.find(params[:id])
    redirect_to user_url(current_user) if current_user != @goal.user && @goal.private
  end
end
