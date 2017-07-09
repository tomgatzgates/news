class Entry < ApplicationRecord
  belongs_to :feed

  def article
    @_article ||= Article.new(self)
  end
end
