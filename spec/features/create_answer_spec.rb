require 'rails_helper'

feature 'User can create an answer to the question', %q{
As an authenticated User
I want to create an answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit questions_path
    click_on 'Show'
    fill_in 'Body', with: 'This is the best in the world answer'
    click_on 'Add new answer'
    expect(page).to have_content 'This is the best in the world answer'
  end

  scenario 'Non authenticated user tries to create answer' do
    visit questions_path
    click_on 'Show'
    fill_in 'Body', with: 'This is the best in the world answer'
    click_on 'Add new answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
 end

end
