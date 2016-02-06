require 'rails_helper'

feature 'user can register in the system', %q{
In order to be User
As a Guest
I want to register in the system
} do

  scenario 'register in the system' do
    visit root_url
    click_on 'Sign up'
    fill_in 'Email', with: 'omg@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end
