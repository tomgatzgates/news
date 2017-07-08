class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params.merge(title: parsed_feed.title))

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

  def parsed_feed
    Feedjira::Feed.fetch_and_parse feed_params[:url]
  end
end
