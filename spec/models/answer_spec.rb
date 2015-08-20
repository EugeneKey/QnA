require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :text }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe 'question notifications' do
    subject { build(:answer) }

    it 'should call notification job after create' do
      expect(NewAnswerNotiferJob).to receive(:perform_later).with(subject)
      subject.save!
    end

    it 'should not call notification job after update' do
      subject.save!
      expect(NewAnswerNotiferJob).to_not receive(:perform_later)
      subject.touch
    end
  end
end
