# frozen_string_literal: true

class SurveyModal::ContentComponent < ViewComponent::Base
  def initialize(survey:, public: false)
    @survey = survey
    @public = public
  end

  private

  attr_reader :survey, :public

  def survey_type_component
    case survey.survey_type
    when 'scale'
      SurveyModal::ScaleComponent
    when 'rating'
      SurveyModal::RatingComponent
    when 'freeform'
      SurveyModal::FreeformComponent
    end
  end

end
