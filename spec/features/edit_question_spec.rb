require_relative "feature_helper"

feature 'Question editing', %q{
In order to correct error in question
As an author of question
I want to edit the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit an question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit this question'
  end

  describe 'Authenticated user' do

    before do
      sign_in question.user
      visit question_path(question)
    end

    scenario 'sees link to edit his question' do
      expect(page).to have_link 'Edit this question'
    end

    scenario 'tries to edit his question', js: true do
      click_on 'Edit this question'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      within '.question-show' do
        expect(page).to_not have_selector 'textarea'
      end
    end

  end

  scenario 'Authenticated user tries to edit other\'s user answer' do
    sign_in user
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit this question'
    end
  end
end
