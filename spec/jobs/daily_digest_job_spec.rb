require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:yesterday_questions) { create_list(:yesterday_question, 2, user: users.first) }
  let!(:new_questions) { create_list(:question, 2, user: users.first) }

  it 'sends daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
