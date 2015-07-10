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

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit his question' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'try to edit his question' do
      click_on 'Edit question'
      fill_in 'Title', with: 'New title his question'
      fill_in 'Text', with: 'New body text his question'
      click_on 'Update'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.text
      expect(page).to have_content 'New title his question'
      expect(page).to have_content 'New body text his question'
      expect(page).to_not have_selector 'edit_question'
    end
  end

  scenario "Authenticated user try to edit other user's question" do
    sign_in another_user
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end
