# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Delete question', '
Only the owner can remove the question

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete own question' do
    sign_in(user)

    visit question_path(question)
    page.find('a.delete-question-link').click

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).not_to have_content 'Title Question'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user cannot delete foreign question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_css('a.delete-question-link')
  end

  scenario 'Non-authenticated user cannot delete question' do
    visit question_path(question)

    expect(page).not_to have_css('a.delete-question-link')
  end
end
