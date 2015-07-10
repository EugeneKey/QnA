require 'features/acceptance_helper'

feature 'Select best answer', '
  In order to be able to indicate the correct answer
  As an Author question
  I want to be able select best answer

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: another_user) }
  given(:answer_best) { create(:answer, best_answer: true, question: question, user: another_user) }

  describe 'Author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'try to select best answer', js: true do
      within "#answer-#{answers[3].id}" do
        click_on 'Accept answer'
        expect(page).to have_content 'Best answer'
        expect(page).to_not have_content 'Accept answer'
        expect(page).to have_content 'Cancel accept answer'
      end
    end

    scenario 'try to select another best answer', js: true do
      answer_best
      within "#answer-#{answers[4].id}" do
        click_on 'Accept answer'
        expect(page).to have_content 'Best answer'
        expect(page).to_not have_content 'Accept answer'
        expect(page).to have_content 'Cancel accept answer'
      end
    end

    scenario 'select best answers but best answer is only one', js: true do
      answer_best
      within "#answer-#{answers[4].id}" do
        click_on 'Accept answer'
      end
      within "#answer-#{answer_best.id}" do
        expect(page).to_not have_content 'Best answer'
        expect(page).to have_content 'Accept answer'
        expect(page).to_not have_content 'Cancel accept answer'
      end
    end

    scenario 'select best answer and this answer became the first', js: true do
      within "#answer-#{answers[3].id}" do
        click_on 'Accept answer'
        expect(page).to have_content 'Best answer'
      end
      within '.answer:first-child' do
        expect(page).to have_content 'Best answer'
        expect(page).to_not have_content 'Accept answer'
        expect(page).to have_content 'Cancel accept answer'
        expect(page).to have_content answers[3].text
      end
    end

    scenario 'cancel best answer', js: true do
      answer_best
      visit question_path(question)
      click_on 'Cancel accept answer'
      expect(page).to_not have_content 'Best answer'
      expect(page).to_not have_content 'Cancel accept answer'
    end
  end

  describe 'Another user' do
    before do
      answer_best
      sign_in another_user
      visit question_path(question)
    end
    scenario 'try to select best answer', js: true do
      expect(page).to_not have_content 'Accept answer'
    end
    scenario 'try to cancel best answer', js: true do
      expect(page).to_not have_content 'Cancel accept answer'
    end
  end
end
