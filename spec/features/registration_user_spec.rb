require_relative 'acceptance_helper'

feature 'User registration', %q{
  In order to be able to ask question and create answer
  As an User
  I want to be able to sign up
} do
  scenario 'User try to sign up' do
    visit root_path
    click_on 'Sign Up'
    fill_in 'Email', with: 'acceptance@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
    expect(current_path).to eq root_path
  end
end
