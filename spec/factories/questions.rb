FactoryGirl.define do
  factory :question do
    association(:user)
    sequence(:title) { |i| "Title Question #{i}" }
    text 'Text Question'
  end

  factory :yesterday_question, class: 'Question' do
    association(:user)
    sequence(:title) { |i| "Title Yesterday Question #{i}" }
    text 'Text Question'
    created_at { 1.day.ago }
  end

  factory :invalid_question, class: 'Question' do
    association(:user)
    titile nil
    text nil
  end
end
