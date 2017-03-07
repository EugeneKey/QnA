# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/notify
  def notify
    SubscriptionMailer.notify
  end
end
