class TrackingController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!
  skip_before_action :set_yoha_cookies
  skip_before_action :set_current_authenticated_user

  def visits
    return head :not_found unless params[:survey_id]
    return head :ok if Visit.exists?(survey_id: params[:survey_id], visit_token: visit_params[:visit_token], path: visit_params[:path])

    AddVisitJob.perform_later(request.user_agent, request.remote_ip, visit_params, params[:survey_id])
    head :created
  end

  def identify
    splatted_attrs = identify_params
      .merge(extra_attributes: identify_params.except(:email, :uid, :account)).slice(:email, :uid, :account, :extra_attributes)
      .merge({visitor_token: params[:visitor_token]})
    VisitorIdentity.find_or_initialize_by(splatted_attrs.slice(:email, :uid, :visitor_token)).tap do |vi|
      vi.extra_attributes = splatted_attrs[:extra_attributes] || {}
      vi.account = splatted_attrs[:account] || {}
      vi.save
    end
    head :created
  end

  def events
    VisitorEvent.create(visitor_token: params[:visitor_token], event: params[:event], survey_id: params[:survey_id])
    head :created
  end

  private

  def visit_params
    params.require(:tracking).permit(
      :js, :landing_page, :path, :referrer, :screen_width, :screen_height,
      :visit_token, :visitor_token
    )
  end

  def identify_params
    params.require(:tracking).permit!
  end
end
