require_relative 'acceptance_helper'

feature 'View list questions', %q{
  All user can do it
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'Authenticated user view list questions' do
    sign_in(user)
    visit root_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'Non-authenticated user view list questions' do
    visit root_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
