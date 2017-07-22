class Entry < ApplicationRecord
  ATTRS = [
    :author,
    :categories,
    :content,
    :image,
    :last_modified,
    :links,
    :published,
    :summary,
    :updated,
  ].freeze

  belongs_to :feed
  store :data, accessors: ATTRS

  def forward
    Nokogiri::HTML.parse(summary || content).text
  end

  def article
    @_article ||= Article.new(self)
  end
end
