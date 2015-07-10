require 'features/acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an Author answer
  I want to be able to attach files

' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User add file when write answer', js: true do
    within '.new_answer' do
      fill_in 'answer[text]', with: 'Some text for answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create Answer'
    end
    within '.answer' do
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'User add several files when write answer', js: true do
    within '.new-answer-form' do
      fill_in 'answer[text]', with: 'Some text for answer'
      click_link 'add files'
      within '.nested-fields:first-child' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      within '.nested-fields:nth-child(2)' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end
      click_on 'Create'
    end

    within '.answer' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'User add file while editing existing answer', js: true do
    answer
    visit question_path(question)
    click_link 'Edit answer'

    within '.edit_answer' do
      click_on 'add files'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
    end
    expect(page).to have_link 'spec_helper.rb'
  end
end
