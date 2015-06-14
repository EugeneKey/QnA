require 'rails_helper'

feature 'Create answer to question', %q{
  In order to give answers to questions
  As an authenticated user
  I want to be able to respond to current questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer to question' do
    sign_in(user)
    visit questions_path
    click_on 'Title Question'
    click_on 'Create Answer'
    fill_in 'Text', with: 'Some text for answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Some text for answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user trying to create question' do
    visit questions_path
    click_on 'Title Question'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
