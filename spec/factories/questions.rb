FactoryGirl.define do
  factory :question do
    association(:user)
    sequence(:title) { |i| "Title Question #{i}" }
    text 'Text Question'
  end

  factory :invalid_question, class: 'Question' do
    association(:user)
    titile nil
    text nil
  end
end
