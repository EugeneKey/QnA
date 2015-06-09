FactoryGirl.define do
  factory :question do
    sequence(:title) { |i| "Title Question #{i}" }
    text 'Text Question'
  end

  factory :invalid_question, class: 'Question' do
    titile nil
    text nil
  end
end
