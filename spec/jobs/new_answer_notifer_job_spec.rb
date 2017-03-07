# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NewAnswerNotiferJob, type: :job do
  let(:question) { create(:question) }
  let(:author) { question.user }
  let(:subscribed_user) { create(:user) }
  let(:answer) { create(:answer, question: question) }

  it 'sendses email to subscribers' do
    create(:subscription, question: question, user: subscribed_user)
    create(:user)

    [author, subscribed_user].each do |subscriber|
      expect(SubscriptionMailer).to receive(:notify)
        .with(subscriber, answer)
        .and_call_original
    end
    NewAnswerNotiferJob.perform_now(answer)
  end
end
