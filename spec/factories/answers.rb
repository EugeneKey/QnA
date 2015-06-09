FactoryGirl.define do
  factory :answer do
    association(:question)
    text 'MyText'
  end

  factory :invalid_answer, class: 'Answer' do
    association(:question)
    text nil
  end
end
