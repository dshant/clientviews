class Account < ApplicationRecord
  LIMIT_ATTRIBUTES = %i(surveys responses integrations, visits)

  has_many :users
  has_many :surveys
  has_many :responses, through: :surveys
  has_many :visits, through: :surveys
  has_many :integrations
  has_one :slack, class_name: 'Integration::Slack', dependent: :destroy
  has_many :api_keys


  def plan
    Plan.find_by(plan_signup_id: plan_id)
  end

  def limits
    OpenStruct.new(Plan.find_by(plan_signup_id: plan_id).to_h.slice(*LIMIT_ATTRIBUTES))
  end

  def responses_this_month
    responses.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
  end

  def visits_this_month
    visits.select(:visitor_token).where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).distinct
  end
end
