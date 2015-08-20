class SubscriptionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.notify.subject
  #
  def notify(user, answer)
    @answer = answer
    mail to: user.email, subject: 'New answer from your subscription Question'
  end
end
