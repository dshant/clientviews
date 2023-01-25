class Api::V1::Zapier::SubscriptionsController < Api::V1::ZapierController

  def create
    render json: { error: 'Invalid Token' }, status: 401 and return unless valid?

    render json: { error: 'Missing Survey ID' }, status: 401 and return if params[:survey_id].blank?

    render json: { success: true } and return if params[:hookUrl].include?('fake-subscription-url')

     zap_sub = Zap.where(survey_id: params[:survey_id], zapier_id: params[:zap])
            .first_or_initialize.tap do |zap|
              zap.hook_url = params[:hookUrl]
            end

    if zap_sub.save
      render json: { id: zap_sub.id }
    else
      render json: {error: 'Please contact Userveys Support'}, status: 400
    end

  end

  def destroy
    render json: { error: 'Invalid Token' } and return unless valid?

    render json: { error: 'Missing ID' }, status: 401 and return if params[:id].blank?

    render json: { success: true } and return if params[:hookUrl].include?('fake-subscription-url')

    Zap.find_by(id: params[:id]).destroy

    render json: { success: true }
  end

  private

  def valid?
    current_resource_account.present?
  end

end