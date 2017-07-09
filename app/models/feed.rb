class Feed < ApplicationRecord
  before_create :set_title

  def find_article_by_slug(article_slug)
    data[article_slug]
  end

  def articles
    @_articles ||= data.values
  end

  def slug
    Base64.urlsafe_encode64(url)
  end

  private

  def set_title
    self.title = parsed.title
  end

  def parsed
    @_parsed ||= Feedjira::Feed.fetch_and_parse url
  end

  def data
    Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      Rails.logger.info "Caching feed articles: #{cache_key}"

      parsed.entries.reduce({}) do |obj, entry|
        article = Article.new(entry, self)
        obj[article.slug] = article
        obj
      end
    end
  end

  def cache_key
    [id, 'articles'].join('/')
  end
end
