# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Question subscription', '
  In order to notification about new answers from subscribed question
  As an authenticated user
  I want to be able to subscribe to question

' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }
  given(:subscribe) { create(:subscription, question: question, user: user) }

  scenario 'Non-authenticated user tries to subscribe' do
    visit question_path(question)

    expect(page).not_to have_css('.subscribe-link')
    expect(page).not_to have_css('.unscribe-link')
  end

  scenario 'Authenticated user subscribes to question', js: true do
    sign_in(user)
    visit question_path(question)

    page.find('a.subscribe-link').trigger('click')

    expect(page).not_to have_css('.subscribe-link')
    expect(page).to have_css('.unscribe-link')
  end

  scenario 'Authenticated user unscribes to question', js: true do
    subscribe
    sign_in(user)

    visit question_path(question)

    page.find('a.unscribe-link').trigger('click')

    expect(page).to have_css('.subscribe-link')
    expect(page).not_to have_css('.unscribe-link')
  end

  scenario 'Author of question opens his question page' do
    sign_in(user)
    visit question_path(user_question)

    expect(page).not_to have_css('.subscribe-link')
    expect(page).not_to have_css('.unscribe-link')
  end
end
