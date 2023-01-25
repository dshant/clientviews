class AddPlanIdToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :plan_id, :string
  end
end
