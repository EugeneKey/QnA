# frozen_string_literal: true
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
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe 'subscription' do
    subject(:question) { build(:question, user: author) }
    let(:author) { create(:user) }

    it 'subscribes author to his question after create' do
      expect { question.save! }.to change(author.subscriptions, :count).by(1)
    end

    it 'does not subscribe after update' do
      question.save!
      expect(question).not_to receive(:subscribe_author)
      question.update(text: 'some text for update')
    end
  end
end
