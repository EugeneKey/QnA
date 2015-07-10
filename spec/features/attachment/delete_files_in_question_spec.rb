require 'features/acceptance_helper'

feature 'Delete files from question', '
  In order to fix mistake attachments
  As an author question
  I want to be able to deletes files

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  describe 'Authenticated owner question user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'have link to delete attachment' do
      within '.attachments' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'delete file from question', js: true do
      within '.attachments' do
        click_on 'Delete'

        expect(page).to_not have_link attachment.file.identifier
      end
    end
  end

  scenario 'Non-owner question user try to delete attachment from question' do
    sign_in another_user
    visit question_path(question)

    within '.attachments' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user try to delete attachment from question' do
    visit question_path(question)

    within '.attachments' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
