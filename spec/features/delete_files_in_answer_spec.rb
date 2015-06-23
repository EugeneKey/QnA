require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order to fix mistake attachments
  As an author answer
  I want to be able to deletes files
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }
  given(:answer) { create(:answer, question: question ,user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe "Authenticated owner answer user" do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario "have link to delete attachment" do
      within '.list-answers .attachments' do
        expect(page).to have_link "Delete"
      end
    end

    scenario 'delete file from answer', js: true do
      within '.list-answers .attachments' do
        click_on 'Delete'

        expect(page).to_not have_link attachment.file.identifier
      end
    end
  end

  scenario "Non-owner answer user try to delete attachment from answer" do
    sign_in another_user
    visit question_path(question)

    within '.list-answers .attachments' do
      expect(page).to_not have_link "Delete"
    end
  end

  scenario "Non-authenticated user try to delete attachment from answer" do
    visit question_path(question)

    within '.list-answers .attachments' do
      expect(page).to_not have_link "Delete"
    end
  end
end