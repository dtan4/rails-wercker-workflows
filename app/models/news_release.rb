class NewsRelease < ActiveRecord::Base
  validates_presence_of :released_on
  validates_presence_of :title
  validates_presence_of :body

  def title_with_date
    "#{released_on.strftime('%Y-%m-%d')}: #{title}"
  end
end
