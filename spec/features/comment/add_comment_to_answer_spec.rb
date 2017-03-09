# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Add comment to answer', '
  In order to discuss the answer
  As an authenticated user
  I want to be able to comment the answer

' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user add comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer .answer-comments' do
      click_on 'add a comment'
      fill_in 'comment[text]', with: 'Some text for comment'
      click_on 'Create comment'
    end

    within '.answer' do
      expect(page).to have_content 'Some text for comment'
    end
  end

  scenario 'Non-authenticated user trying add comment', js: true do
    visit question_path(question)

    expect(page).not_to have_content 'add a comment'
  end
end
