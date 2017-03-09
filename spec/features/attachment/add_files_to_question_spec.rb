# frozen_string_literal: true
require 'features/acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my question
  As an Author question
  I want to be able to attach files

' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User add file when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Some text for question'
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb'
  end

  scenario 'User add several files when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Some text for question'
    click_link 'add more files'
    within '.nested-fields:first-child' do
      attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    end
    within '.nested-fields:nth-child(2)' do
      attach_file 'File', Rails.root.join('spec', 'rails_helper.rb')
    end
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'User add file while editing existing question', js: true do
    question
    visit edit_question_path(question)

    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    click_on 'Update Your Question'

    expect(page).to have_link 'spec_helper.rb'
  end
end
