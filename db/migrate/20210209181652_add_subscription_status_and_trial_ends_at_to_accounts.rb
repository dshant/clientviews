class AddSubscriptionStatusAndTrialEndsAtToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :subscription_status, :string
    add_column :accounts, :trial_ends_at, :datetime
  end
end
