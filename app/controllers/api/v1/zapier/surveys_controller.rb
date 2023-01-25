class Api::V1::Zapier::SurveysController < Api::V1::ZapierController
  protect_from_forgery with: :null_session
  
  def index
    render json: { error: 'Invalid Token' }, status: 401 and return unless valid?

    render json: survey_lists
  end

  def responses
    render json: { error: 'Invalid Token' }, status: 401 and return unless valid?

    render json: { error: 'Missing Survey ID' }, status: 401 and return if params[:survey_id].blank?

    render json: responses_lists
  end

  def valid?
    current_resource_account.present?
  end

  def survey_lists
    current_resource_account&.surveys&.order(created_at: :desc)&.map do |survey|
      {
        id: survey.id,
        name: survey.name
      }
    end || []
  end

  def responses_lists
    Survey.find_by(id: params[:survey_id]).responses&.order(created_at: :desc)&.map do |response|
      {
        id: response.id,
        value: response.value,
        email: response.email,
        extra_text: response.extra_text
      }
    end || []
  end

end
