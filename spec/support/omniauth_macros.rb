module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new ({
      provider: provider.to_s,
      uid:      '123456789',
      info:     {
      email: provider != :twitter ? 'existemail@example.com' : nil
      }
    })
  end
end
