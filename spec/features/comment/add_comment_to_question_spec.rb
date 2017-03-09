# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Add comment to question', '
  In order to discuss the question
  As an authenticated user
  I want to be able to comment the question

' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user add comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-comments' do
      click_on 'add a comment'
      fill_in 'comment[text]', with: 'Some text for comment'
      click_on 'Create comment'
    end

    expect(page).to have_content 'Some text for comment'
  end

  scenario 'Non-authenticated user trying add comment', js: true do
    visit question_path(question)

    expect(page).not_to have_content 'add a comment'
  end
end
