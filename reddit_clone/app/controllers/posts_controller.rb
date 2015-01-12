class PostsController < ApplicationController
  before_action :only_correct_user!, only: [:edit, :update]

  def new
    @post = Post.new(sub_id: params[:sub_id].to_i)
  end

  def create
    #@post = Post.new(post_params)
    #@post.author_id = current_user.id
    #fail
    @post = current_user.posts.new(post_params)
    if @post.save
      #@post.sub_ids = params[:post][:sub_ids]
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to user_url(current_user)
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :author_id, :content, sub_ids: [])
  end

  def only_correct_user!
    redirect_to user_url(current_user) if current_user != Post.find(params[:id]).author
  end
end
