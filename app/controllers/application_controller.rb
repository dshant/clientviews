class ApplicationController < ActionController::Base
 include Pagy::Backend

 impersonates :user

  before_action :authenticate_user!
  before_action :set_yoha_cookies, if: -> { !current_user.nil? }
  before_action :set_current_authenticated_user, if: -> { !current_user.nil? }

  def set_yoha_cookies
    cookies[:yoha_visit] ||= {value: SecureRandom.uuid, expires: 4.hours.from_now, domain: Rails.env.production? ? 'app.userveys.com' : 'localhost', secure: true}
    cookies[:yoha_visitor] ||= {value: SecureRandom.uuid, expires: 2.years.from_now, domain: Rails.env.production? ? 'app.userveys.com' : 'localhost', secure: true}

    survey_id = Rails.env.production? ? '085dcd94-a5fe-4e50-bf34-498d50c8d8e0' : Account&.first&.surveys&.first&.id || Survey&.first&.id || '123'
    unless Visit.exists?(survey_id: survey_id, visit_token: cookies[:yoha_visit], path: request.path)
      AddVisitJob.perform_later(request.user_agent, request.remote_ip, {visitor_token: cookies[:yoha_visitor], visit_token: cookies[:yoha_visit], path: request.path}, survey_id)
    end
    IdentifyJob.perform_later(current_user, cookies[:yoha_visitor])
  end

  def set_current_authenticated_user
    Current.user = current_user
  end

  def after_sign_in_path_for(resource)
    survey_id = Rails.env.production? ? '085dcd94-a5fe-4e50-bf34-498d50c8d8e0' : nil
    SigninEventJob.perform_later(resource, cookies[:yoha_visitor], survey_id)
    return root_url
  end


  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      'devise'
    elsif controller_path.include?('error')
      'error'
    else
      'application'
    end
  end
end
