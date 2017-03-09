# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Question editing', '
  In order to fix mistake
  As an author question
  I want to be able to edit my question

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user trying to edit answer' do
    visit question_path(question)

    expect(page).not_to have_css('a.edit-question-link')
  end

  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit his question' do
      expect(page).to have_css('a.edit-question-link')
    end

    scenario 'try to edit his question' do
      page.find('a.edit-question-link').click

      fill_in 'Title', with: 'New title his question'
      fill_in 'Text', with: 'New body text his question'
      click_on 'Update Your Question'

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.text
      expect(page).to have_content 'New title his question'
      expect(page).to have_content 'New body text his question'
      expect(page).not_to have_css('.edit-question')
    end
  end

  scenario "Authenticated user try to edit other user's question" do
    sign_in another_user
    visit question_path(question)

    expect(page).not_to have_css('.edit-question')
  end
end
