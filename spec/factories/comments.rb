# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    text 'Text comment'
    association(:commentable)
    association(:user)
  end

  factory :invalid_comment, class: 'Comment' do
    text nil
    association(:commentable)
    association(:user)
  end
end
