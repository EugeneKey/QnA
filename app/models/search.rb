# frozen_string_literal: true
class Search < ActiveRecord::Base
  def self.search(query, type = nil, page = 1)
    return unless query.present?
    if type.present?
      ThinkingSphinx.search(
        query, classes: [type.constantize], page: page, per_page: 20
      )
    else
      ThinkingSphinx.search(
        query, page: page, per_page: 20
      )
    end
  end
end
