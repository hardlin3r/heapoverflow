require 'rails_helper'

feature 'User can create an answer to the question', %q{
As an authenticated User
I want to create an answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_text) { 'This is an answer body' }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: answer_text
    click_on 'Create'
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer_text
    end
  end

  scenario 'Non authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: answer_text
    click_on 'Create'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
 end

end
