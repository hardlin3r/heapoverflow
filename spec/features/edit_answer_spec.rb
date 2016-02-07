require_relative "feature_helper"

feature 'Answer editing', %q{
In order to correct error in answer
As an author of answer
I want to edit the answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    before do
      sign_in answer.user
      visit question_path(question)
    end

    scenario 'sees link to edit his answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
   end

  end

  scenario 'Authenticated user tries to edit other\'s user answer' do
    sign_in user
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
