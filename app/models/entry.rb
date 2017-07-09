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

  def article
    @_article ||= Article.new(self)
  end
end
