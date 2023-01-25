class Surveys::VisitorsController < ApplicationController
  require 'pagy/extras/array'
  def index
    @survey = Survey.find(params[:survey_id])
    @visit_all = @survey.visits.load
    @pagy, @visits = pagy_array(@visit_all.to_a.sort_by(&:updated_at).reverse.uniq(&:visitor_token))
  end

end
