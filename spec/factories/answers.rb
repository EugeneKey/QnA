# frozen_string_literal: true
FactoryGirl.define do
  factory :answer do
    association(:question)
    association(:user)
    sequence(:text) { |i| "Text Answer #{i}" }
  end

  factory :invalid_answer, class: 'Answer' do
    association(:question)
    association(:user)
    text nil
  end
end
