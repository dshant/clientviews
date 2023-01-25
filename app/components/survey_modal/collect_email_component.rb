# frozen_string_literal: true

class SurveyModal::CollectEmailComponent < ViewComponent::Base
  def initialize(survey:)
    @survey = survey
  end

end
