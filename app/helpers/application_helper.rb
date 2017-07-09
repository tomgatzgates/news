module ApplicationHelper
  def published(date)
    return unless date
    date.strftime("Published on %A, %e %B %Y")
  end
end
