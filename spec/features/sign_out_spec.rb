require_relative 'feature_helper'

feature 'User can sign out from the system', %q{
In order to leave the system
As a signed in User
I want to sign our from the system
} do

  given!(:user) { create(:user) }

  scenario 'signed in user wants to sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'unauthenticated user wants to sign out' do
    visit root_url
    expect(page).to_not have_content 'Sign out'
  end

end
