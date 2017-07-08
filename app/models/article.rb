class Article
  def initialize(entry)
    @entry = entry
  end

  delegate :id, :url, :title, :summary, to: :entry
  delegate :content, :author, :date_published, :lead_image_url, to: :page

  def slug
    Base64.urlsafe_encode64(id)
  end

  private

  def page
    @_mercury ||= mercury.parse(url)
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
