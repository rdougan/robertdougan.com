class Admin::PostsController < ApplicationController
  before_filter :authenticate
  before_filter :add_cls

  def add_cls
    @cls = "admin"
  end

  def authenticate
    authenticate_or_request_with_http_basic "Admin" do |user_name, password|
      user_name == "admin" && password == ENV['ADMIN_PASSWORD']
    end
  end

  def index
    @posts = Post.all(:order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_posts_url, :notice => 'Post was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to admin_posts_url, :notice => 'Post was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to admin_posts_url }
    end
  end
end
