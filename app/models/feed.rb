class Feed < ApplicationRecord
  def parsed
    Feedjira::Feed.fetch_and_parse url
  end

  def articles
    @_articles ||= data.values
  end

  def find_article_by_slug(slug)
    data[slug]
  end

  private

  def data
    @_data ||= parsed.entries.reduce({}) do |obj, entry|
      article = Article.new(entry, self)
      obj[article.slug] = article
      obj
    end
  end
end
