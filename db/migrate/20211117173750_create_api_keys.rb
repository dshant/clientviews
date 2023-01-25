class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :api_key
      t.boolean :enabled
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
