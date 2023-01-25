class BillingController < ApplicationController
  def index
    resp = Stripe::BillingPortal::Session.create({
                                                   customer: Current.account.stripe_customer_id,
                                                   return_url: root_url
                                                 })
    redirect_to resp.url
  end
end
