require_relative 'feature_helper'


feature 'OAuth twitter' do
  before { OmniAuth.config.test_mode = true }
  before { visit root_path }


  scenario 'user already exists' do
    mock_auth_hash(:twitter)
    user = create(:user)
    user.authorizations.create(provider: 'twitter', uid: '123456789')

    click_on 'Sign in'
    click_on 'Sign in with Twitter'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'failure' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

    click_on 'Sign in'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end


end
