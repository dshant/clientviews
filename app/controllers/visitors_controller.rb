class VisitorsController < ApplicationController
  require 'pagy/extras/array'

  def index
    visit_all = Visit.includes(:survey, :visitor_identity).where(survey_id: Current.account.surveys.pluck(:id).compact)
    if params[:s].present?
      puts "Searching\n\n\n"
      visit_all = visit_all.visit_search(params[:s])
    end
    @visit_all = visit_all.load
    @pagy, @visits = pagy_array(@visit_all.to_a.sort_by(&:updated_at).reverse.uniq(&:visitor_token)) #pax1xgy(Visit.select('DISTINCT on (visitor_token) *').includes(:visitor_identity, :survey).where(survey_id: Current.account.surveys.pluck(:id).compact).order([{visitor_token: :desc},{created_at: :desc}]))
  end

  def show
    if VisitorIdentity.exists?(params[:id])
      @visitor = VisitorIdentity.includes([{visits: :survey},{events: :survey} ]).find(params[:id])
    else
      visits = Visit.where(visitor_token: params[:id])
      events = VisitorEvent.where(visitor_token: params[:id])
      @visitor = OpenStruct.new(
        {
          extra_attributes: {},
          email: nil,
          uid: params[:id],
          account: {},
          visits: visits,
          events: events
        }
      )
    end
  end
end
