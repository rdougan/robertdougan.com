class PostsController < ApplicationController
  def index
    @posts = Post.all(:order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def show
    @post = Post.find_by_permalink(params[:permalink])

    respond_to do |format|
      format.html
    end
  end

  def feed
    @posts = Post.all(:order => "created_at DESC", :limit => 20)

    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end
end
