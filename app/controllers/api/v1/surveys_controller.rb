class Api::V1::SurveysController < Api::BaseController
  protect_from_forgery with: :null_session
  
  def show
    @survey = Survey.find_by(id: params[:id])
    if @survey.present?
      render 'surveys/show'
    else
      render json: { error: 'Survey not found' }
    end
  end
end
