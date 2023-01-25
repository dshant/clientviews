class Api::V1::ResponsesController < Api::BaseController
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def create
    ## No Sites for now
    # puts "re #{request.headers.inspect}"
    # @site = Site.by_url(request.headers['origin'])
    # render json: { error: 'Site not registered' }, status: 422 and return unless @site.present?

    puts "sid: #{params[:survey_id]}"
    @survey = Survey.find_by(id: params[:survey_id])
    render json: { error: 'Survey does not exist' }, status: 422 and return unless @survey.present?

    @response = @survey.responses.new(response_params)
    @response.survey_type = @survey.survey_type # Type at time of response

    if @response.save
      unless response_params[:video_feedback_data].blank?
        VideoResponseUploadJob.perform_later(@response)
      end
      if params[:visitor_id]
        VisitorEventJob.perform_later(nil, params[:visitor_id], 'Survey Response', params[:survey_id])
        IdentifyJob.perform_later(OpenStruct.new({email: response_params[:email], id: params[:visitor_id] }), params[:visitor_id]) unless response_params[:email].blank?
      end
      ResponseEventJob.perform_later(@response)
      if ActiveModel::Type::Boolean.new.cast(params[:public])
        redirect_to thank_you_path(@survey)
      else
        render json: {message: "Successful"}, status: :created
      end
    else
      Rails.logger.debug("Save error: #{@response.errors.inspect}")
      render json: { error: 'Response could not be saved' }, status: 400
    end
  end

  private

  def response_params
    params.require(:response).permit(:value, :email, :video_feedback_data, :extra_text)
  end
end
