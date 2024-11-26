# frozen_string_literal: true
class CommentsController < ApplicationController
  def index
    @comments=Comment.all
  end
  def new
    @post=Post.find(params[:post_id])
    @comment=@post.comments.new
  end
  def create
    @post=Post.find(params[:post_id])
    @comment=@post.comments.build(comment_params.merge(user_id: current_user.id))
    if @comment.save
      redirect_to @post,notice: 'comment is successfully created'
    else
      render :new
    end
  end
  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
