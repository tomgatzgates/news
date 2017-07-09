class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def log(str, type = :info)
    Rails.logger.send(type, "#{log_id}: #{str}")
  end

  private

  def log_id
    "#{self.class.to_s}[#{id}]"
  end
end
