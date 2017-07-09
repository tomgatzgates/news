class Article
  def initialize(entry)
    @entry = entry
  end

  delegate :feed, :id, :url, :title, to: :entry
  delegate :content, :author, :date_published, :lead_image_url, :dek, to: :page

  def published_at
    return unless date_published
    Date.parse(date_published)
  end

  private

  attr_reader :entry

  def page
    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      begin
        entry.log "caching article: #{cache_key}"
        mercury.parse(url)
      rescue => e
        entry.log "error parsing article: #{e}", :error
        entry.touch :reported_at
      end
    end
  end

  def cache_key
    ['entry', id, 'article'].join('/')
  end

  # TODO: extract this out
  def mercury
    @_mercury ||= MercuryParser::Client.new(
      api_key: Rails.application.secrets.mercury_token
    )
  end
end

# Mercury attrs
# =============
# title
# content
# author
# date_published
# lead_image_url
# dek
# next_page_url
# url
# domain
# excerpt
# word_count
# direction
# total_pages
# rendered_pages
