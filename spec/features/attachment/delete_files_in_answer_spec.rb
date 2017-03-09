# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Delete files from answer', '
  In order to fix mistake attachments
  As an author answer
  I want to be able to deletes files

' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe 'Authenticated owner answer user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'have link to attachment' do
      within '.answers .attachments' do
        expect(page).to have_link attachment.file.identifier
      end
    end

    scenario 'not have link to delete attachment' do
      within '.answers .attachments' do
        expect(page).not_to have_css('a.delete-attach')
        expect(page).not_to have_css('span.glyphicon-remove')
      end
    end

    scenario 'have link to delete attachment when edit answer', js: true do
      page.find('a.edit-answer-link').trigger('click')

      expect(page).to have_css('a.delete-attach')
      expect(page).to have_css('span.glyphicon-remove')
    end

    scenario 'delete file from answer', js: true do
      page.find('a.edit-answer-link').trigger('click')
      page.find('a.delete-attach').trigger('click')

      expect(page).not_to have_link attachment.file.identifier
    end
  end

  scenario 'Non-owner answer user try to delete attachment from answer' do
    sign_in another_user
    visit question_path(question)

    expect(page).not_to have_css('a.delete-attach')
    expect(page).not_to have_css('span.glyphicon-remove')
  end

  scenario 'Non-authenticated user try to delete attachment from answer' do
    visit question_path(question)

    expect(page).not_to have_css('a.delete-attach')
    expect(page).not_to have_css('span.glyphicon-remove')
  end
end
