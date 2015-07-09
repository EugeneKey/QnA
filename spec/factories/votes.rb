FactoryGirl.define do
  factory :vote do
    value 1
    association :user
    association :votable
  end

  factory :vote_question, class: 'Vote' do
    value 1
    association :user
    association :votable, factory: :question
  end
end