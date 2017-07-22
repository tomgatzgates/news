class FeedsController < ApplicationController
  def index
    @feeds = Feed.all.order(created_at: :desc)
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      flash[:notice] = "Successfully created feed!"
      redirect_to feed_path(@feed)
    else
      flash[:alert] = "Error creating new feed!"
      render :new
    end
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end
end
