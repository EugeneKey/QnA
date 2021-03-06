# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@mail.com" }
    password '12345678'
    password_confirmation '12345678'
  end
end
