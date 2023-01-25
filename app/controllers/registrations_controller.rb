class RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash.except(:account), session)

    if controller_name == 'registrations' && action_name == 'create'
      account ||= Account.create(name: hash[:account][:name])
      account.api_keys.create(api_key: "U_"+SecureRandom.alphanumeric(64))
      Billable.update_stripe(params[:plan], resource, account)
    end
    resource.account = account
  end

  def after_sign_up_path_for(resource)
    onboard_basics_path # Or :prefix_to_your_route
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :plan, account: [:name])
  end
end
