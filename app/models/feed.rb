class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy

  before_create :set_title, :set_favicon_url
  after_create -> { fetch_entries('inline') }

  def parsed
    @_parsed ||= begin
      log 'fetching feed: url'
      Feedjira::Feed.fetch_and_parse url
    end
  end

  def fetch_entries(inline = false)
    if inline
      FetchEntriesJob.new(id).perform_now
    else
      FetchEntriesJob.perform_later(id)
    end
  end

  private

  def set_title
    self.title = parsed.title
  end

  def set_favicon_url
    self.favicon_url = feed_image || Favicon.new(host).url
  end

  def feed_image
    parsed.try(:image).try(:url)
  end

  def host
    URI.parse(url).host
  end
end
