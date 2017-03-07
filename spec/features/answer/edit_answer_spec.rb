# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Answer editing', '
  In order to fix mistake
  As an author answer
  I want to be able to edit my answer

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit his answer' do
      within '.answer-options' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Edit your answer:', with: 'Edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.text
        expect(page).to have_content 'Edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end

  scenario "Authenticated user try to edit other user's answer" do
    sign_in another_user
    visit question_path(question)
    expect(page).not_to have_link 'Edit answer'
  end

  scenario 'Non-authenticated user trying to edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit answer'
  end
end
