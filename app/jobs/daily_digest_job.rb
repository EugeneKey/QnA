# frozen_string_literal: true
class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    return unless Question.yesterday

    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
