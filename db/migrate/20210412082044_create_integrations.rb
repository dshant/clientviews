class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :type
      t.jsonb :settings, null: false, default: {}

      t.timestamps
    end

    add_index :integrations, :settings, using: :gin
  end
end
