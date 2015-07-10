FactoryGirl.define do
  factory :attachment do
    association(:attachable)
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb')))
  end
end
