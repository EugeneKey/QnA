# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'User can sign in via oauth' do
  background { OmniAuth.config.test_mode = true }

  scenario 'facebook with email and not require confirmation email' do
    sign_in_facebook

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    within '.alert' do
      expect(page)
        .to have_content 'Successfully authenticated from Facebook account.'
    end
  end

  scenario 'twitter with confirmation email' do
    sign_in_twitter

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Continue'

    open_email 'test@test.com'
    current_email.click_link 'Confirm my account'
    clear_emails

    expect(page)
      .to have_content 'Your email address has been successfully confirmed.'
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    within '.alert' do
      expect(page)
        .to have_content 'Successfully authenticated from Twitter account.'
    end
  end
end

feature 'User can not sign in via oauth' do
  background { OmniAuth.config.test_mode = true }

  scenario 'twitter without confirmation email' do
    sign_in_twitter

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Continue'

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    within '.alert' do
      expect(page)
        .to have_content "You have to confirm your \
                          email address before continuing."
    end
  end
end
