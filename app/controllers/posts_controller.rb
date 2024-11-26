class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :find_path, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:comments).all
    @comments = Comment.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(query_params)
    if @post.save
      # redirect_to @post, notice: 'Post is successfully created.'
      respond_to do |format|
        format.html{redirect_to posts_path,notice: 'Post is successfully created.'}
        format.js
      end
    else
      respond_to do |format|
        format.html{render :new,status: :unprocessable_entity}
        format.js{render :create_error}
      end
      # render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    # @post=Post.find(params[:id])
  end

  def update
    # @post=Post.find(params[:id])
    if @post.update(query_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @post = current_user.posts.find_by(id: params[:id])
    if @post&.destroy
      redirect_to root_path, status: :see_other, notice: 'Post was successfully deleted.'
    else
      redirect_to root_path, status: :see_other,
                             alert: 'Post could not be found or you are not authorized to delete it.'
    end
  end

  private

  def query_params
    params.require(:post).permit(:title, :description)
  end

  def find_path
    @post = current_user.posts.find_by(id: params[:id])

    return unless @post.nil?

    redirect_to root_path, alert: 'Post could not be found or you are not authorized to delete it.'
  end
end
