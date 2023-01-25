class StripeSubscriptionUpdateJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = ::Stripe::Event.retrieve(event_id)
    account = Account.find_by(stripe_customer_id: event.data.object.customer)
    return unless account

    data = {
      subscription_status: event.data.object.status
    }

    data = data.merge(trial_ends_at: Time.at(event.data.object.trial_end)) unless event&.data&.object&.trial_end.nil?

    if !!event&.data&.object&.plan&.id
       plan = Plan.find_by(stripe_price_id: event&.data&.object&.plan&.id)
       data = data.merge(plan_id: plan.plan_signup_id)
    end

    account.update(data)
  end
end
