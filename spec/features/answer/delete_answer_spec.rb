# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Delete answer', '
  Only the owner can remove the answer

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete own answer', js: true do
    sign_in(user)
    visit question_path(question)
    page.find('.delete-answer-link').trigger('click')

    expect(page).not_to have_content 'Text Answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user cannot delete foreign answer' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_css('a.delete-answer-link')
  end

  scenario 'Non-authenticated user cannot delete answer' do
    visit question_path(question)

    expect(page).not_to have_css('a.delete-answer-link')
  end
end
