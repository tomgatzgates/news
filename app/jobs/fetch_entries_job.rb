class FetchEntriesJob < ApplicationJob
  queue_as :default

  def perform(feed_id)
    @feed_id = feed_id

    Rails.logger.info "starting processing entries for Feed[#{feed_id}]"

    feed ? create_entries : log_error
  end

  private

  def create_entries
    Entry.transaction do
      new_entries.each do |entry|
        feed.log "creating Entry for entry.id"
        create_entry(entry)
      end
    end
  end

  def create_entry(entry)
    feed.entries.create!(
      entry_id: entry.id,
      title: entry.title,
      url: entry.url
    )
  end

  def new_entries
    # TODO: could this be smarter and not need to fetch all ids ever.
    # If a feed is only the N latest, should we limit the Entry search to N.
    existing_entry_ids = feed.entries.pluck(:entry_id)
    parsed_entries.select { |entry| !existing_entry_ids.include? entry.id }
  end

  def parsed_entries
    feed.parsed.entries
  end

  def log_error
    Rails.logger.error "cannot find Feed[#{@feed_id}]"
  end

  def feed
    @_feed ||= Feed.find(@feed_id)
  end
end
