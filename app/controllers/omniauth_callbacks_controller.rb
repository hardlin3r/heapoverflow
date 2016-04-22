class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth, only: [:facebook, :twitter]

  def facebook
  end

  def twitter
  end

  private
  def oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.to_s.capitalize ) if is_navigational_format?
    else
      flash[:alert] = "Error: cannot find or create a user with these credentials"
      redirect_to new_user_session_url
    end
  end

end
