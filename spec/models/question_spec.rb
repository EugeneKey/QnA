require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :text }
  it { should validate_presence_of :user_id }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to :user }

  it { should accept_nested_attributes_for :attachments }
end
