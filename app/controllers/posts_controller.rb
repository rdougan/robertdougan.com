class PostsController < ApplicationController
  def index
    @posts = Post.all(:order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def feed
    @posts = Post.all(:order => "created_at DESC", :limit => 20)

    respond_to do |format|
      format.atom { render :layout => false }
      # format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end

  def show
    @post = Post.find_by_permalink(params[:permalink])

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
        format.html { redirect_to @post, :notice => 'Post was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end
end
