class SubsController < ApplicationController

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    if @sub.moderator_id != current_user.id
      flash[:errors] = ["Can't edit others' posts!"]
      redirect_to sub_url(@sub)
    end
  end

  def index
    @subs = Sub.all
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def only_deal_with_own_subs
    redirect_to user_url(current_user) if @sub.moderator_id != current_user.id
  end
end
