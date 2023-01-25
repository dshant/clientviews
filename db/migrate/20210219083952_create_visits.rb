class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :visit_token
      t.string :visitor_token
      t.string :ip
      t.string :user_agent
      t.string :referring_domain
      t.string :full_location
      t.string :path
      t.string :browser
      t.string :os
      t.string :device_type

      t.timestamps
    end
  end
end
