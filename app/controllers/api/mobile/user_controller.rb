class Api::Mobile::UserController < Api::BaseController
  skip_before_action :verify_authenticity_token

  rescue_from StandardError do |exception|
    Rails.logger.error exception
    render json: {message: "Error"}, status: 500
  end
  
  def auth
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      render json: {message: "Success", token: user.generate_jwt}
    else
      render json: { error:  'Email or password is invalid'  }, status: :unprocessable_entity
    end
  end

  private

end