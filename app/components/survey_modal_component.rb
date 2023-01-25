# frozen_string_literal: true

class SurveyModalComponent < ViewComponent::Base
  def initialize(survey:)
    @survey = survey
  end

end
