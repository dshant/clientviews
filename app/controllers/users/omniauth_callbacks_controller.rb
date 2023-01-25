class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      plan = request.env['omniauth.params']['state']
      @user = User.from_omniauth(request.env['omniauth.auth'], plan)

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url(plan: plan), alert: @user.errors.full_messages.join("\n")
      end
  end

  def slack
    @account = Account.find_by(id: request.env['omniauth.params']['state'])
    path = request.env['omniauth.params']['post_redirect'] || root_path
    auth = request.env['omniauth.auth']

    puts "! #{pp auth}"

    integration = @account
                  .integrations
                  .where(type: 'Integration::Slack')
                  .where("settings -> 'uid' ? :id", id: auth.uid)
                  .first_or_initialize.tap do |intg|
      intg.settings = intg.settings.merge({
                                            uid: auth.uid,
                                            access_token: auth.credentials.token,
                                            team_id: auth.info.team.id,
                                            team_name: auth.info.team.name,
                                            user_id: auth.info.authed_user.id
                                          })
      intg.save
    end
    flash = integration.persisted? ? { success: 'Slack Account has been authorized and connected' } : { error: 'Slack Account could not be authorized' }
    redirect_to(path, flash)
  end
end
