module Billable
  DEFAULT_PLAN = 'free0221'

  def self.update_stripe(plan, user, account)
    plan = Plan.find_by(plan_signup_id: (plan.blank? ? DEFAULT_PLAN : plan))
    customer = Stripe::Customer.create({
                                         email: user.email,
                                         description: "Account: #{account.id}"
                                       })
    subscription = Stripe::Subscription.create({
                                                 customer: customer.id,
                                                 items: [
                                                   { price: plan.stripe_price_id },
                                                 ],
                                                 trial_period_days: 14
                                               })
    account.update(
      stripe_customer_id: customer.id,
      stripe_subscription_id: subscription.id,
      subscription_status: subscription.status,
      trial_ends_at: Time.at(subscription.trial_end),
      plan_id: plan.plan_signup_id
    )
  end
end
