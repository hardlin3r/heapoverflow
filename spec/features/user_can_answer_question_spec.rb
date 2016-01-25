require 'rails_helper'

feature 'User can answer question', %q{
  In order to help other users
  As a User
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { 'This is an answer to the question' }

  scenario 'Registered user can answer the question' do
    sign_in(user)
    visit root_url
    click_on 'Show'
    fill_in 'Body', with: answer
    click_on 'Add new answer'
    expect(page).to have_content answer
  end

  scenario 'Non-authenticated user cannot answer the question' do
    visit root_url
    first(:link, 'Show').click
    fill_in 'Body', with: answer
    click_on 'Add new answer'
    expect(page).to have_content "You need to sign in or sign up before continuing"
  end

end
