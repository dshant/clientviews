class CreateVisitorEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :visitor_events, id: :uuid do |t|
      t.string :visitor_token
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :event

      t.timestamps
    end
  end
end
