class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy

  before_create :set_title
  after_create :create_entries

  def parsed
    @_parsed ||= begin
      log 'fetching feed: url'
      Feedjira::Feed.fetch_and_parse url
    end
  end

  private

  def set_title
    self.title = parsed.title
  end

  def create_entries
    FetchEntriesJob.perform_later(self.id)
  end
end
