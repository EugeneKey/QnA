require 'features/acceptance_helper'

feature 'Create answer to question', %q{
  In order to give answers to questions
  As an authenticated user
  I want to be able to respond to current questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer to question', js: true do
    sign_in user
    visit question_path(question)

    within '.new_answer' do
      fill_in 'answer[text]', with: 'Some text for answer'
      click_on 'Create Answer'
    end

    within '.list-answers' do
      expect(page).to have_content 'Some text for answer'
    end
    expect(current_path).to eq question_path(question)

  end

  scenario 'Authenticated user try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create Answer'

    expect(page).to have_content "Text can't be blank"
  end

  scenario 'Non-authenticated user trying to create answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
