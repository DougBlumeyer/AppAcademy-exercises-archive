class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id

    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      redirect_to post_url(@comment.post)
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def upvote
    @comment = Comment.find(params[:id])
    @comment.votes.create(value: 1)
    redirect_to :back
  end

  def downvote
    @comment = Comment.find(params[:id])
    @comment.votes.create(value: -1)
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
