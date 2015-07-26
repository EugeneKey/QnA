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
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content 'Title Question'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user cannot delete foreign question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user cannot delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
