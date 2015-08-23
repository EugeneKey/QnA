class Search < ActiveRecord::Base
  def self.search(query, type = nil, page = 1)
    return unless query.present?
    return ThinkingSphinx.search(query, page: page,  per_page: 20) unless type.present?
    ThinkingSphinx.search(query, classes: [type.constantize], page: page,  per_page: 20)
  end
end
