# frozen_string_literal: true
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

    scenario 'have link to attachment' do
      expect(page).to have_link attachment.file.identifier
    end

    scenario 'not have link to delete attachment' do
      expect(page).not_to have_css('a.delete-attach')
      expect(page).not_to have_css('span.glyphicon-remove')
    end

    scenario 'have link to delete attachment when edit question' do
      page.find('a.edit-question-link').click

      expect(page).to have_css('a.delete-attach')
      expect(page).to have_css('span.glyphicon-remove')
    end

    scenario 'delete file from question', js: true do
      page.find('a.edit-question-link').trigger('click')
      page.find('a.delete-attach').trigger('click')
      click_on 'Update Your Question'

      expect(page).not_to have_link attachment.file.identifier
    end
  end
end
