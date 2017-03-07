# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Search content', '
  In order to find content
  As a visitor of the site
  I should be able to search information
' do
  given(:user) { create :user, email: 'testuser@mail.com' }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, user: user }
  given!(:comment) {
    create :comment, user: user,
                     commentable: question,
                     commentable_type: 'Question'
  }

  scenario 'User searches all', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'query', with: 'testuser'
        select 'All', from: 'type'
        click_on 'Search'
      end

      within '.search-result' do
        expect(page).to have_content question.title
        expect(page).to have_content question.text
        expect(page).to have_content answer.text
        expect(page).to have_content comment.text
        expect(page).to have_content user.email
      end
    end
  end

  scenario 'User searches question', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'query', with: 'testuser'
        select 'Question', from: 'type'
        click_on 'Search'
      end

      within '.search-result' do
        expect(page).to have_content question.title
        expect(page).to have_content question.text
        expect(page).not_to have_content answer.text
        expect(page).not_to have_content comment.text
        expect(page).not_to have_content user.email
      end
    end
  end

  scenario 'User searches answer', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'query', with: 'testuser'
        select 'Answer', from: 'type'
        click_on 'Search'
      end

      within '.search-result' do
        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.text
        expect(page).to have_content answer.text
        expect(page).not_to have_content comment.text
        expect(page).not_to have_content user.email
      end
    end
  end

  scenario 'User searches comment', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'query', with: 'testuser'
        select 'Comment', from: 'type'
        click_on 'Search'
      end

      within '.search-result' do
        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.text
        expect(page).not_to have_content answer.text
        expect(page).to have_content comment.text
        expect(page).not_to have_content user.email
      end
    end
  end

  scenario 'User searches user', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'query', with: 'testuser'
        select 'User', from: 'type'
        click_on 'Search'
      end

      within '.search-result' do
        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.text
        expect(page).not_to have_content answer.text
        expect(page).not_to have_content comment.text
        expect(page).to have_content user.email
      end
    end
  end
end
