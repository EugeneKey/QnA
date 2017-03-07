# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Vote for the question', '
  In order to be able to select interesting question
  As an authenticated user
  I want to be able to vote

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:vote) { create(:vote, votable: question, user: another_user) }

  scenario 'author question try to voting' do
    sign_in user
    visit question_path(question)

    expect(page).not_to have_link '+'
    expect(page).not_to have_link '-'
    expect(page).not_to have_link 'Cancel vote'
  end

  describe 'another authenticated user' do
    before do
      sign_in another_user
      visit question_path(question)
    end

    scenario 'have link for voting' do
      within "#question-vote-#{question.id}" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
      end
    end

    scenario 'voting up for question', js: true do
      within "#question-vote-#{question.id}" do
        click_on '+'

        expect(page).to have_content '1'
        expect(page).not_to have_link '+'
        expect(page).not_to have_link '-'
        expect(page).to have_link 'Cancel vote'
      end
    end

    scenario 'voting down for question', js: true do
      within "#question-vote-#{question.id}" do
        click_link '-'

        expect(page).to have_content '-1'
        expect(page).not_to have_link '+'
        expect(page).not_to have_link '-'
        expect(page).to have_link 'Cancel vote'
      end
    end

    scenario 'cancel vote for question', js: true do
      vote
      visit question_path(question)

      within "#question-vote-#{question.id}" do
        click_link 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).not_to have_link 'Cancel vote'
      end
    end
  end

  scenario 'non-authenticated user try to voting' do
    visit question_path(question)

    expect(page).not_to have_link '+'
    expect(page).not_to have_link '-'
    expect(page).not_to have_link 'Cancel vote'
  end
end
