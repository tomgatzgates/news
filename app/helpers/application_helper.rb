module ApplicationHelper
  def published(date)
    return unless date
    date.strftime("Published %A, #{date.day.ordinalize} %B %Y")
  end
end
