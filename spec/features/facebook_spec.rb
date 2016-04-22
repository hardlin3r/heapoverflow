require_relative "feature_helper"

feature 'OAuth facebook' do
  before { OmniAuth.config.test_mode = true }
  before { mock_auth_hash(:facebook) }
  before { visit root_path }

  scenario 'successfully' do
    click_on 'Sign in'
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'failure' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    click_on 'Sign in'
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
  end

end
