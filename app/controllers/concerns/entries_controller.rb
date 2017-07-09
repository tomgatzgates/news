class EntriesController < ApplicationController
  def index
    @entries = entries
    @feed = feed
  end

  def show
    @entry = entry
  end

  private

  def entry
    entries.find(params[:id])
  end

  def entries
    feed.entries
  end

  def feed
    Feed.find(params[:feed_id])
  end
end
