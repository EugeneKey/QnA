# frozen_string_literal: true
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
    subject(:answer) { build(:answer) }

    it 'calls notification job after create' do
      expect(NewAnswerNotiferJob).to receive(:perform_later).with(answer)
      answer.save!
    end

    it 'does not call notification job after update' do
      answer.save!
      expect(NewAnswerNotiferJob).not_to receive(:perform_later)
      answer.update(text: 'some text for update')
    end
  end
end
