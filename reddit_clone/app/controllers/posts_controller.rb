class PostsController < ApplicationController

  def new
    @post = Post.new(sub_id: params[:sub_id].to_i)
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      redirect_to post_url(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
