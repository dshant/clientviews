class Api::V1::ZapierController < Api::BaseController
  protect_from_forgery with: :null_session

  rescue_from StandardError do |exception|
    Rails.logger.error exception
    render json: {message: "Error"}, status: 500
  end
  
  def auth
    if current_resource_account.present?
      render json: { account: current_resource_account.name}, status: 200
    else
      render json: { error: 'Account not found' }, status: 403
    end
  end

  private

  def current_resource_account
    Account.includes(:api_keys).find_by(api_keys: {api_key: params[:api_key]})
  end
  helper_method :current_resource_account
end