# frozen_string_literal: true

class SurveyModal::RatingComponent < ViewComponent::Base
  def initialize(survey:)
    @survey = survey
  end

end
