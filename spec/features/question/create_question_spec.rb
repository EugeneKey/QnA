require 'features/acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Some text for question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Some text for question'
    expect(current_path).to eq question_path(question.id - 1)
  end

  scenario 'Non-authenticated user trying to create question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
