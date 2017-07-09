class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy

  before_create :set_title
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
end
