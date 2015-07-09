require 'features/acceptance_helper'

feature 'Vote for the answer', %q{
  In order to be able to select a useful answer
  As an authenticated user
  I want to be able to vote
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:vote) { create(:vote, votable: answer, user: another_user) }

  scenario 'author answer try to voting' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'Cancel vote'
  end

  describe 'another authenticated user' do
    before do
      sign_in another_user
      visit question_path(question)
    end

    scenario 'have link for voting' do
      within "#answer-#{answer.id}" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
      end
    end

    scenario 'voting up for answer', js: true do
      within "#answer-vote-#{answer.id}" do
        click_on '+'

        expect(page).to have_content '1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
      end
    end

    scenario 'voting down for answer', js: true do
      within "#answer-vote-#{answer.id}" do
        click_link '-'

        expect(page).to have_content '-1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
      end
    end

    scenario 'cancel vote for answer', js: true do
      vote
      visit question_path(question)

      within "#answer-vote-#{answer.id}" do
        click_link 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to_not have_link 'Cancel vote'
      end
    end
  end

  scenario 'non-authenticated user try to voting' do
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'Cancel vote'
  end
end