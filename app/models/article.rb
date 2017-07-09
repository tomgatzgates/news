class Article
  def initialize(entry, feed)
    @entry = entry
    @feed = feed
  end

  attr_reader :feed

  delegate :id, :url, :title, :summary, to: :entry
  delegate :content, :author, :date_published, :lead_image_url, :dek, to: :page

  def published_at
    return unless date_published
    Date.parse(date_published)
  end

  def slug
    Base64.urlsafe_encode64(id)
  end

  private

  def page
    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Rails.logger.info "Caching article: #{cache_key}"
      mercury.parse(url)
    end
  end

  def cache_key
    ['articles', slug, 'page'].join('/')
  end

  # TODO: extract this out
  def mercury
    @_mercury ||= MercuryParser::Client.new(api_key: Rails.application.secrets.mercury_token)
  end

  attr_reader :entry
end

# Mercury attrs
# article.title
# article.content
# article.author
# article.date_published
# article.lead_image_url
# article.dek
# article.next_page_url
# article.url
# article.domain
# article.excerpt
# article.word_count
# article.direction
# article.total_pages
# article.rendered_pages
