require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :text }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }
end
