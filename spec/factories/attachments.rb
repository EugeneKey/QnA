# frozen_string_literal: true
FactoryGirl.define do
  factory :attachment do
    association(:attachable)
    file Rack::Test::UploadedFile.new(
      File.open(Rails.root.join('spec', 'rails_helper.rb'))
    )
  end
end
