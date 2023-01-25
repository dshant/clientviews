class AddAccountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :account, null: false, foreign_key: true, type: :uuid
  end
end
