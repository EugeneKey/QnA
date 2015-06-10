require 'rails_helper'

feature 'View the question and all answers to it', %q{
  All user can do it
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Authenticated user view question and answers' do
    sign_in(user)
    question
    answers

    visit root_path
    click_on 'Title Question'

    expect(page).to have_content 'Text Question'
    answers.each do |a|
      expect(page).to have_content a.text
    end
  end

  scenario 'Non-authenticated user view question and answers' do
    question
    answers

    visit root_path
    click_on 'Title Question'

    expect(page).to have_content 'Text Question'
    answers.each do |a|
      expect(page).to have_content a.text
    end
  end
end
