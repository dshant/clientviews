class DashboardController < ApplicationController
  def index
    @surveys = Current.account.surveys.includes(:responses).order(created_at: :asc)
    @responses = Response.includes(:survey).where(survey_id: Current.account.surveys.pluck(:id)).order(created_at: :desc).limit(10)
  end
end
