# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:yesterday_questions) do
    create_list(:yesterday_question, 2, user: users.first)
  end

  it 'sends daily digest' do
    create_list(:question, 2, user: users.first)

    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
