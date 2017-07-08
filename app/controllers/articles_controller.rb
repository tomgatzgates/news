class ArticlesController < ApplicationController
  def index
    @articles = Feed.all
  end

  def show
    @article = article
    @feed = feed
  end

  private

  def article
    feed.find_article_by_slug(params[:id])
  end

  def feed
    Feed.find(params[:feed_id])
  end
end
